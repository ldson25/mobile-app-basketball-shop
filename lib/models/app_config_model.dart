class AppConfigModel {
  final bool maintenanceMode;
  final bool codEnabled;
  final bool bankTransferEnabled;
  final bool eWalletEnabled;
  final bool freeShippingEnabled;
  final String storeName;
  final String currency;
  final String supportPhone;

  const AppConfigModel({
    this.maintenanceMode = false,
    this.codEnabled = true,
    this.bankTransferEnabled = true,
    this.eWalletEnabled = true,
    this.freeShippingEnabled = true,
    this.storeName = 'Kinetic',
    this.currency = 'VND',
    this.supportPhone = '1900 0000',
  });

  AppConfigModel copyWith({
    bool? maintenanceMode,
    bool? codEnabled,
    bool? bankTransferEnabled,
    bool? eWalletEnabled,
    bool? freeShippingEnabled,
    String? storeName,
    String? currency,
    String? supportPhone,
  }) {
    return AppConfigModel(
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      codEnabled: codEnabled ?? this.codEnabled,
      bankTransferEnabled: bankTransferEnabled ?? this.bankTransferEnabled,
      eWalletEnabled: eWalletEnabled ?? this.eWalletEnabled,
      freeShippingEnabled: freeShippingEnabled ?? this.freeShippingEnabled,
      storeName: storeName ?? this.storeName,
      currency: currency ?? this.currency,
      supportPhone: supportPhone ?? this.supportPhone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintenanceMode': maintenanceMode,
      'codEnabled': codEnabled,
      'bankTransferEnabled': bankTransferEnabled,
      'eWalletEnabled': eWalletEnabled,
      'freeShippingEnabled': freeShippingEnabled,
      'storeName': storeName,
      'currency': currency,
      'supportPhone': supportPhone,
    };
  }

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      maintenanceMode: json['maintenanceMode'] == true,
      codEnabled: json['codEnabled'] != false,
      bankTransferEnabled: json['bankTransferEnabled'] != false,
      eWalletEnabled: json['eWalletEnabled'] != false,
      freeShippingEnabled: json['freeShippingEnabled'] != false,
      storeName: (json['storeName'] ?? 'Kinetic').toString(),
      currency: (json['currency'] ?? 'VND').toString(),
      supportPhone: (json['supportPhone'] ?? '1900 0000').toString(),
    );
  }
}
