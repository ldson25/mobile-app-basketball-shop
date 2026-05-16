import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  // Lọc đơn hàng theo status
  List<OrderModel> getOrdersByStatus(OrderStatus? status) {
    if (status == null) return _orders;
    return _orders.where((order) => order.status == status).toList();
  }

  // Tạo đơn hàng mới
  void createOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingCost,
    required double total,
    required String shippingAddress,
    required String phoneNumber,
  }) {
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: '#${(_orders.length + 1000).toString()}',
      date: DateTime.now(),
      status: OrderStatus.pending,
      trackingNumber: 'IK${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      subtotal: subtotal,
      shippingCost: shippingCost,
      total: total,
      shippingAddress: shippingAddress,
      phoneNumber: phoneNumber,
    );
    
    _orders.insert(0, order); // Thêm vào đầu danh sách
    notifyListeners();
  }

  // Cập nhật trạng thái đơn hàng
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = OrderModel(
        id: _orders[index].id,
        orderNumber: _orders[index].orderNumber,
        date: _orders[index].date,
        status: newStatus,
        trackingNumber: _orders[index].trackingNumber,
        items: _orders[index].items,
        subtotal: _orders[index].subtotal,
        shippingCost: _orders[index].shippingCost,
        total: _orders[index].total,
        shippingAddress: _orders[index].shippingAddress,
        phoneNumber: _orders[index].phoneNumber,
      );
      notifyListeners();
    }
  }

  // Lấy chi tiết đơn hàng
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Xóa đơn hàng (admin)
  void clearAllOrders() {
    _orders.clear();
    notifyListeners();
  }
}