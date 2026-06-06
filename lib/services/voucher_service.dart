import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/voucher_model.dart';
import 'admin_activity_log_service.dart';

class VoucherService extends ChangeNotifier {
  static final VoucherService _instance = VoucherService._internal();
  factory VoucherService() => _instance;

  VoucherService._internal() {
    _subscribe();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AdminActivityLogService _logService = AdminActivityLogService();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  List<VoucherModel> _vouchers = _defaultVouchers;

  static const List<VoucherModel> _defaultVouchers = [
    VoucherModel(
      id: 'member10',
      code: 'MEMBER10',
      name: 'Member welcome',
      discountType: VoucherDiscountType.percent,
      discountValue: 10,
      minOrderValue: 0,
      targetTier: VoucherTargetTier.member,
    ),
    VoucherModel(
      id: 'vip20',
      code: 'VIP20',
      name: 'VIP exclusive',
      discountType: VoucherDiscountType.percent,
      discountValue: 20,
      minOrderValue: 5000000,
      targetTier: VoucherTargetTier.vip,
    ),
    VoucherModel(
      id: 'kinetic50',
      code: 'KINETIC50',
      name: 'Kinetic bonus',
      discountType: VoucherDiscountType.fixed,
      discountValue: 50000,
      minOrderValue: 1000000,
      targetTier: VoucherTargetTier.all,
    ),
  ];

  List<VoucherModel> get vouchers => List.unmodifiable(_vouchers);

  void _subscribe() {
    _subscription = _firestore.collection('vouchers').snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          _vouchers = _defaultVouchers;
        } else {
          _vouchers = snapshot.docs.map((doc) {
            final data = doc.data();
            return VoucherModel.fromJson({
              ...data,
              'id': data['id'] ?? doc.id,
            });
          }).where((voucher) => voucher.code.isNotEmpty).toList()
            ..sort((a, b) {
              if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
              return a.code.compareTo(b.code);
            });
        }
        notifyListeners();
      },
      onError: (_) {
        _vouchers = _defaultVouchers;
        notifyListeners();
      },
    );
  }

  Future<void> addVoucher(VoucherModel voucher) async {
    _vouchers = [voucher, ..._vouchers.where((item) => item.id != voucher.id)];
    notifyListeners();
    await _firestore.collection('vouchers').doc(voucher.id).set(voucher.toJson());
    await _logService.record(
      action: 'Saved voucher ${voucher.code}',
      targetType: 'voucher',
      targetId: voucher.id,
    );
  }

  Future<void> toggleVoucher(String id) async {
    final index = _vouchers.indexWhere((voucher) => voucher.id == id);
    if (index == -1) return;

    final copy = [..._vouchers];
    copy[index] = copy[index].copyWith(isActive: !copy[index].isActive);
    _vouchers = copy;
    notifyListeners();
    await _firestore.collection('vouchers').doc(id).set(copy[index].toJson());
    await _logService.record(
      action: 'Toggled voucher ${copy[index].code}',
      targetType: 'voucher',
      targetId: id,
    );
  }

  Future<void> removeVoucher(String id) async {
    _vouchers = _vouchers.where((voucher) => voucher.id != id).toList();
    notifyListeners();
    await _firestore.collection('vouchers').doc(id).delete();
    await _logService.record(
      action: 'Removed voucher',
      targetType: 'voucher',
      targetId: id,
    );
  }

  double calculateDiscount(
    String code,
    double subtotal, {
    VoucherTargetTier userTier = VoucherTargetTier.member,
  }) {
    final normalized = code.trim().toUpperCase();
    VoucherModel? voucher;
    for (final item in _vouchers) {
      if (item.code.toUpperCase() == normalized && item.isActive) {
        voucher = item;
        break;
      }
    }
    if (voucher == null ||
        subtotal < voucher.minOrderValue ||
        !_matchesTargetTier(voucher, userTier)) {
      return 0;
    }

    switch (voucher.discountType) {
      case VoucherDiscountType.percent:
        return subtotal * (voucher.discountValue / 100);
      case VoucherDiscountType.fixed:
        return voucher.discountValue;
      case VoucherDiscountType.freeShipping:
        return 0;
    }
  }

  bool _matchesTargetTier(VoucherModel voucher, VoucherTargetTier userTier) {
    if (voucher.targetTier == VoucherTargetTier.all) return true;
    return voucher.targetTier == userTier;
  }

  Future<void> seedDefaultVouchers() async {
    final batch = _firestore.batch();
    for (final voucher in _defaultVouchers) {
      batch.set(
        _firestore.collection('vouchers').doc(voucher.id),
        voucher.toJson(),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
