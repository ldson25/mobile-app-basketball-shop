class ShippingAddressModel {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String street;
  final String ward;
  final String district;
  final String city;
  final String country;
  final bool isDefault;

  const ShippingAddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    this.country = 'VIET NAM',
    this.isDefault = false,
  });

  String get fullAddress {
    return [street, ward, district, city, country]
        .where((part) => part.trim().isNotEmpty)
        .join(', ');
  }

  ShippingAddressModel copyWith({
    String? id,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? country,
    bool? isDefault,
  }) {
    return ShippingAddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, String> toCheckoutData({
    required String shippingMethod,
    required String shippingLabel,
    required double shippingCost,
  }) {
    return {
      'fullName': fullName,
      'country': country,
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
      'phone': phone,
      'shippingMethod': shippingMethod,
      'shippingLabel': shippingLabel,
      'shippingCost': shippingCost.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullName': fullName,
      'phone': phone,
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      street: (json['street'] ?? '').toString(),
      ward: (json['ward'] ?? '').toString(),
      district: (json['district'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      country: (json['country'] ?? 'VIET NAM').toString(),
      isDefault: json['isDefault'] == true,
    );
  }
}
