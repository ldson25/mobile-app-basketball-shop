enum VoucherTargetTier {
  all,
  member,
  vip,
}

enum VoucherDiscountType {
  percent,
  fixed,
  freeShipping,
}

class VoucherModel {
  final String id;
  final String code;
  final String name;
  final VoucherDiscountType discountType;
  final double discountValue;
  final double minOrderValue;
  final VoucherTargetTier targetTier;
  final bool isActive;

  const VoucherModel({
    required this.id,
    required this.code,
    required this.name,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    required this.targetTier,
    this.isActive = true,
  });

  String get targetLabel {
    switch (targetTier) {
      case VoucherTargetTier.all:
        return 'Tat ca';
      case VoucherTargetTier.member:
        return 'Member';
      case VoucherTargetTier.vip:
        return 'VIP';
    }
  }

  String get discountLabel {
    switch (discountType) {
      case VoucherDiscountType.percent:
        return '${discountValue.round()}%';
      case VoucherDiscountType.fixed:
        return '${discountValue.round()}d';
      case VoucherDiscountType.freeShipping:
        return 'Free ship';
    }
  }

  VoucherModel copyWith({
    String? id,
    String? code,
    String? name,
    VoucherDiscountType? discountType,
    double? discountValue,
    double? minOrderValue,
    VoucherTargetTier? targetTier,
    bool? isActive,
  }) {
    return VoucherModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minOrderValue: minOrderValue ?? this.minOrderValue,
      targetTier: targetTier ?? this.targetTier,
      isActive: isActive ?? this.isActive,
    );
  }
}
