class ShippingRuleModel {
  final String id;
  final String name;
  final String method;
  final double cost;
  final String area;
  final bool isActive;

  const ShippingRuleModel({
    required this.id,
    required this.name,
    required this.method,
    required this.cost,
    this.area = 'VIET NAM',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'method': method,
      'cost': cost,
      'area': area,
      'isActive': isActive,
    };
  }

  factory ShippingRuleModel.fromJson(Map<String, dynamic> json) {
    final rawCost = json['cost'];
    return ShippingRuleModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      method: (json['method'] ?? '').toString(),
      cost: rawCost is num
          ? rawCost.toDouble()
          : double.tryParse((rawCost ?? '0').toString()) ?? 0,
      area: (json['area'] ?? 'VIET NAM').toString(),
      isActive: json['isActive'] != false,
    );
  }
}
