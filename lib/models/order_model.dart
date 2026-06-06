import 'package:flutter/material.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipping,
  delivered,
  cancelled,
  returned,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Cho xu ly';
      case OrderStatus.confirmed:
        return 'Da xac nhan';
      case OrderStatus.shipping:
        return 'Dang giao';
      case OrderStatus.delivered:
        return 'Da giao';
      case OrderStatus.cancelled:
        return 'Da huy';
      case OrderStatus.returned:
        return 'Da tra';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.amber;
      case OrderStatus.confirmed:
        return Colors.lightGreen;
      case OrderStatus.shipping:
        return Colors.lightBlue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.grey;
    }
  }
}

class OrderModel {
  final String id;
  final String? userId;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final String trackingNumber;
  final List<CartItemModel> items;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;
  final String shippingAddress;
  final String phoneNumber;
  final String customerName;
  final String paymentMethod;
  final String shippingMethod;
  final String? voucherCode;

  OrderModel({
    required this.id,
    this.userId,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.trackingNumber,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    this.discount = 0,
    required this.total,
    required this.shippingAddress,
    required this.phoneNumber,
    this.customerName = '',
    this.paymentMethod = 'cash',
    this.shippingMethod = 'free',
    this.voucherCode,
  });

  int get totalQuantity {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? orderNumber,
    DateTime? date,
    OrderStatus? status,
    String? trackingNumber,
    List<CartItemModel>? items,
    double? subtotal,
    double? shippingCost,
    double? discount,
    double? total,
    String? shippingAddress,
    String? phoneNumber,
    String? customerName,
    String? paymentMethod,
    String? shippingMethod,
    String? voucherCode,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderNumber: orderNumber ?? this.orderNumber,
      date: date ?? this.date,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      customerName: customerName ?? this.customerName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      voucherCode: voucherCode ?? this.voucherCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderNumber': orderNumber,
      'date': date.toIso8601String(),
      'status': status.name,
      'trackingNumber': trackingNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'discount': discount,
      'total': total,
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'shippingMethod': shippingMethod,
      'voucherCode': voucherCode,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final parsedItems = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : <CartItemModel>[];
    final statusName = json['status'] as String?;

    return OrderModel(
      id: (json['id'] ?? '').toString(),
      userId: json['userId'] as String?,
      orderNumber: (json['orderNumber'] ?? '').toString(),
      date: _parseDate(json['date']),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == statusName,
        orElse: () => OrderStatus.pending,
      ),
      trackingNumber: (json['trackingNumber'] ?? '').toString(),
      items: parsedItems,
      subtotal: _parseDouble(json['subtotal']),
      shippingCost: _parseDouble(json['shippingCost']),
      discount: _parseDouble(json['discount']),
      total: _parseDouble(json['total']),
      shippingAddress: (json['shippingAddress'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      customerName: (json['customerName'] ?? '').toString(),
      paymentMethod: (json['paymentMethod'] ?? 'cash').toString(),
      shippingMethod: (json['shippingMethod'] ?? 'free').toString(),
      voucherCode: json['voucherCode'] as String?,
    );
  }
}

DateTime _parseDate(dynamic value) {
  if (value is DateTime) return value;
  if (value != null && value.toString().isNotEmpty) {
    final parsed = DateTime.tryParse(value.toString());
    if (parsed != null) return parsed;
  }
  return DateTime.now();
}

double _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse((value ?? '0').toString()) ?? 0;
}
