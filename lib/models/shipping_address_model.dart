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
}
