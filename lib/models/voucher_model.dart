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
        return 'Tất cả';
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
        return '${discountValue.round()}đ';
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'discountType': discountType.name,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'targetTier': targetTier.name,
      'isActive': isActive,
    };
  }

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    final discountTypeName =
        (json['discountType'] ?? json['type'] ?? json['discount_type'])
            .toString()
            .trim();
    final targetTierName =
        (json['targetTier'] ?? json['tier'] ?? json['target_tier'])
            .toString()
            .trim();
    final rawCode = (json['code'] ?? json['voucherCode'] ?? '').toString();
    final code = rawCode.trim().toUpperCase();
    final rawName = (json['name'] ?? json['title'] ?? '').toString().trim();

    return VoucherModel(
      id: (json['id'] ?? '').toString(),
      code: code,
      name: rawName.isEmpty ? code : rawName,
      discountType: VoucherDiscountType.values.firstWhere(
        (type) => type.name == discountTypeName,
        orElse: () => _parseDiscountType(discountTypeName),
      ),
      discountValue: _parseDouble(
        json['discountValue'] ??
            json['value'] ??
            json['discount'] ??
            json['discountPercent'] ??
            json['amount'],
      ),
      minOrderValue: _parseDouble(
        json['minOrderValue'] ?? json['minOrder'] ?? json['minimumOrder'],
      ),
      targetTier: VoucherTargetTier.values.firstWhere(
        (tier) => tier.name == targetTierName,
        orElse: () => VoucherTargetTier.all,
      ),
      isActive: json['isActive'] != false && json['active'] != false,
    );
  }
}

VoucherDiscountType _parseDiscountType(String value) {
  final normalized = value.toLowerCase().replaceAll('_', '').replaceAll('-', '');
  if (normalized.contains('free')) return VoucherDiscountType.freeShipping;
  if (normalized.contains('fixed') ||
      normalized.contains('amount') ||
      normalized.contains('cash')) {
    return VoucherDiscountType.fixed;
  }
  return VoucherDiscountType.percent;
}

double _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse((value ?? '0').toString()) ?? 0;
}
