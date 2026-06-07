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
    seedDefaultVouchers();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AdminActivityLogService _logService = AdminActivityLogService();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  List<VoucherModel> _vouchers = _defaultVouchers;

  static const List<VoucherModel> _defaultVouchers = [
    VoucherModel(
      id: 'member10',
      code: 'MEMBER10',
      name: 'Thành viên mới',
      discountType: VoucherDiscountType.percent,
      discountValue: 10,
      minOrderValue: 0,
      targetTier: VoucherTargetTier.member,
    ),
    VoucherModel(
      id: 'vip20',
      code: 'VIP20',
      name: 'Đặc quyền VIP',
      discountType: VoucherDiscountType.percent,
      discountValue: 20,
      minOrderValue: 5000000,
      targetTier: VoucherTargetTier.vip,
    ),
    VoucherModel(
      id: 'kinetic50',
      code: 'KINETIC50',
      name: 'Tri ân khách hàng',
      discountType: VoucherDiscountType.fixed,
      discountValue: 50000,
      minOrderValue: 1000000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'freeship01',
      code: 'FREESHIP',
      name: 'Miễn phí vận chuyển',
      discountType: VoucherDiscountType.freeShipping,
      discountValue: 0,
      minOrderValue: 500000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'hoops30',
      code: 'HOOPS30',
      name: 'Lễ hội bóng rổ',
      discountType: VoucherDiscountType.percent,
      discountValue: 30,
      minOrderValue: 2000000,
      targetTier: VoucherTargetTier.member,
    ),
    VoucherModel(
      id: 'sneakerhead',
      code: 'SNEAKERHEAD',
      name: 'Săn giày xịn',
      discountType: VoucherDiscountType.fixed,
      discountValue: 100000,
      minOrderValue: 3000000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'summer25',
      code: 'SUMMER25',
      name: 'Bộ sưu tập mùa Hè',
      discountType: VoucherDiscountType.percent,
      discountValue: 25,
      minOrderValue: 1500000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'weekend50',
      code: 'WEEKEND50',
      name: 'Bùng nổ cuối tuần',
      discountType: VoucherDiscountType.fixed,
      discountValue: 50000,
      minOrderValue: 800000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'newgear',
      code: 'NEWGEAR',
      name: 'Lên đồ cực chất',
      discountType: VoucherDiscountType.percent,
      discountValue: 15,
      minOrderValue: 1000000,
      targetTier: VoucherTargetTier.member,
    ),
    VoucherModel(
      id: 'baller200',
      code: 'BALLER200',
      name: 'Trang bị thi đấu',
      discountType: VoucherDiscountType.fixed,
      discountValue: 200000,
      minOrderValue: 5000000,
      targetTier: VoucherTargetTier.vip,
    ),
    VoucherModel(
      id: 'court15',
      code: 'COURT15',
      name: 'Làm chủ sân đấu',
      discountType: VoucherDiscountType.percent,
      discountValue: 15,
      minOrderValue: 1200000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'jersey20',
      code: 'JERSEY20',
      name: 'Sale áo đấu',
      discountType: VoucherDiscountType.percent,
      discountValue: 20,
      minOrderValue: 800000,
      targetTier: VoucherTargetTier.member,
    ),
    VoucherModel(
      id: 'mamba24',
      code: 'MAMBA24',
      name: 'Tinh thần Mamba',
      discountType: VoucherDiscountType.percent,
      discountValue: 24,
      minOrderValue: 2400000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'flashbuy',
      code: 'FLASHBUY',
      name: 'Flash Sale bất ngờ',
      discountType: VoucherDiscountType.fixed,
      discountValue: 80000,
      minOrderValue: 1500000,
      targetTier: VoucherTargetTier.all,
    ),
    VoucherModel(
      id: 'mvp100',
      code: 'MVP100',
      name: 'Phần thưởng MVP',
      discountType: VoucherDiscountType.fixed,
      discountValue: 100000,
      minOrderValue: 0,
      targetTier: VoucherTargetTier.vip,
    ),
  ];

  List<VoucherModel> get vouchers => List.unmodifiable(_vouchers);

  void _subscribe() {
    _subscription = _firestore.collection('vouchers').snapshots().listen(
      (snapshot) {
        final fetchedVouchers = snapshot.docs.map((doc) {
          final data = doc.data();
          return VoucherModel.fromJson({
            ...data,
            'id': data['id'] ?? doc.id,
          });
        }).where((voucher) => voucher.code.isNotEmpty).toList();

        final allVouchers = [...fetchedVouchers];
        for (final dv in _defaultVouchers) {
          if (!fetchedVouchers.any((fv) => fv.code.toUpperCase() == dv.code.toUpperCase())) {
            allVouchers.add(dv);
          }
        }

        _vouchers = allVouchers
          ..sort((a, b) {
            if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
            return a.code.compareTo(b.code);
          });
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
