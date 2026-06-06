import 'order_model.dart';

class OrderStatusHistoryModel {
  final String id;
  final String orderId;
  final OrderStatus fromStatus;
  final OrderStatus toStatus;
  final String changedBy;
  final DateTime changedAt;
  final String note;

  const OrderStatusHistoryModel({
    required this.id,
    required this.orderId,
    required this.fromStatus,
    required this.toStatus,
    required this.changedBy,
    required this.changedAt,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'fromStatus': fromStatus.name,
      'toStatus': toStatus.name,
      'changedBy': changedBy,
      'changedAt': changedAt.toIso8601String(),
      'note': note,
    };
  }

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistoryModel(
      id: (json['id'] ?? '').toString(),
      orderId: (json['orderId'] ?? '').toString(),
      fromStatus: _statusFromName(json['fromStatus'] as String?),
      toStatus: _statusFromName(json['toStatus'] as String?),
      changedBy: (json['changedBy'] ?? '').toString(),
      changedAt: DateTime.tryParse((json['changedAt'] ?? '').toString()) ??
          DateTime.now(),
      note: (json['note'] ?? '').toString(),
    );
  }
}

OrderStatus _statusFromName(String? name) {
  return OrderStatus.values.firstWhere(
    (status) => status.name == name,
    orElse: () => OrderStatus.pending,
  );
}
