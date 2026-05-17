import 'package:flutter/material.dart';

import '../models/voucher_model.dart';

class VoucherService extends ChangeNotifier {
  static final VoucherService _instance = VoucherService._internal();
  factory VoucherService() => _instance;
  VoucherService._internal();

  final List<VoucherModel> _vouchers = [
    const VoucherModel(
      id: 'member10',
      code: 'MEMBER10',
      name: 'Member welcome',
      discountType: VoucherDiscountType.percent,
      discountValue: 10,
      minOrderValue: 0,
      targetTier: VoucherTargetTier.member,
    ),
    const VoucherModel(
      id: 'vip20',
      code: 'VIP20',
      name: 'VIP exclusive',
      discountType: VoucherDiscountType.percent,
      discountValue: 20,
      minOrderValue: 5000000,
      targetTier: VoucherTargetTier.vip,
    ),
    const VoucherModel(
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

  void addVoucher(VoucherModel voucher) {
    _vouchers.insert(0, voucher);
    notifyListeners();
  }

  void toggleVoucher(String id) {
    final index = _vouchers.indexWhere((voucher) => voucher.id == id);
    if (index == -1) return;

    _vouchers[index] = _vouchers[index].copyWith(
      isActive: !_vouchers[index].isActive,
    );
    notifyListeners();
  }

  void removeVoucher(String id) {
    _vouchers.removeWhere((voucher) => voucher.id == id);
    notifyListeners();
  }
}
