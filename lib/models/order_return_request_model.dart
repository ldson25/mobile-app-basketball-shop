class OrderReturnRequestModel {
  final String id;
  final String orderId;
  final String userId;
  final List<String> itemIds;
  final String reason;
  final String condition;
  final String refundMethod;
  final double refundAmount;
  final String requestType;
  final String note;
  final String status;
  final DateTime createdAt;

  const OrderReturnRequestModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.itemIds,
    required this.reason,
    required this.condition,
    required this.refundMethod,
    this.refundAmount = 0,
    this.requestType = 'return',
    this.note = '',
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'itemIds': itemIds,
      'reason': reason,
      'condition': condition,
      'refundMethod': refundMethod,
      'refundAmount': refundAmount,
      'requestType': requestType,
      'note': note,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderReturnRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderReturnRequestModel(
      id: (json['id'] ?? '').toString(),
      orderId: (json['orderId'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      itemIds: (json['itemIds'] as List?)?.map((item) => item.toString()).toList() ??
          <String>[],
      reason: (json['reason'] ?? '').toString(),
      condition: (json['condition'] ?? '').toString(),
      refundMethod: (json['refundMethod'] ?? '').toString(),
      refundAmount: _parseDouble(json['refundAmount']),
      requestType: (json['requestType'] ?? 'return').toString(),
      note: (json['note'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse((value ?? '0').toString()) ?? 0;
}
