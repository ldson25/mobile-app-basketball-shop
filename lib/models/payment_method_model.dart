enum PaymentMethodType {
  cash,
  bankTransfer,
  eWallet,
  creditCard,
}

class PaymentMethodModel {
  final String id;
  final String userId;
  final PaymentMethodType type;
  final String label;
  final String provider;
  final String maskedNumber;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.label,
    this.provider = '',
    this.maskedNumber = '',
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'label': label,
      'provider': provider,
      'maskedNumber': maskedNumber,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String?;
    return PaymentMethodModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      type: PaymentMethodType.values.firstWhere(
        (type) => type.name == typeName,
        orElse: () => PaymentMethodType.cash,
      ),
      label: (json['label'] ?? '').toString(),
      provider: (json['provider'] ?? '').toString(),
      maskedNumber: (json['maskedNumber'] ?? '').toString(),
      isDefault: json['isDefault'] == true,
    );
  }
}
