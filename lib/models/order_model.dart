import 'package:flutter/material.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.amber;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final String trackingNumber;
  final List<CartItemModel> items;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String shippingAddress;
  final String phoneNumber;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.trackingNumber,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.shippingAddress,
    required this.phoneNumber,
  });

  int get totalQuantity {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}