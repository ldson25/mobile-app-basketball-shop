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
}
