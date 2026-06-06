import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/order_return_request_model.dart';
import '../models/order_status_history_model.dart';
import 'admin_activity_log_service.dart';

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;

  OrderService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _subscription?.cancel();
      _orders = [];
      if (user == null) {
        notifyListeners();
        return;
      }
      _subscribeUserOrders(user.uid);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AdminActivityLogService _logService = AdminActivityLogService();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  void _subscribeUserOrders(String uid) {
    _subscription = _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      _orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromJson({
          ...data,
          'id': data['id'] ?? doc.id,
        });
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    });
  }

  Future<void> loadAllOrdersForAdmin() async {
    final snapshot = await _firestore.collection('orders').get();
    _orders = snapshot.docs.map((doc) {
      final data = doc.data();
      return OrderModel.fromJson({
        ...data,
        'id': data['id'] ?? doc.id,
      });
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  List<OrderModel> getOrdersByStatus(OrderStatus? status) {
    if (status == null) return _orders;
    return _orders.where((order) => order.status == status).toList();
  }

  void createOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingCost,
    double discount = 0,
    required double total,
    required String shippingAddress,
    required String phoneNumber,
    String customerName = '',
    String paymentMethod = 'cash',
    String shippingMethod = 'free',
    String? voucherCode,
  }) {
    final uid = _uid;
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    final order = OrderModel(
      id: id,
      userId: uid,
      orderNumber: '#${(_orders.length + 1000).toString()}',
      date: now,
      status: OrderStatus.pending,
      trackingNumber: 'IK${now.millisecondsSinceEpoch}',
      items: items,
      subtotal: subtotal,
      shippingCost: shippingCost,
      discount: discount,
      total: total,
      shippingAddress: shippingAddress,
      phoneNumber: phoneNumber,
      customerName: customerName,
      paymentMethod: paymentMethod,
      shippingMethod: shippingMethod,
      voucherCode: voucherCode,
    );

    _orders.insert(0, order);
    notifyListeners();
    _firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus newStatus, {
    String note = '',
  }) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;

    final previous = _orders[index];
    if (previous.status == newStatus) return;
    if (previous.status == OrderStatus.cancelled ||
        previous.status == OrderStatus.returned) {
      return;
    }

    final updated = _orders[index].copyWith(status: newStatus);
    _orders[index] = updated;
    notifyListeners();

    final orderRef = _firestore.collection('orders').doc(orderId);
    final historyRef = orderRef.collection('status_history').doc();
    final history = OrderStatusHistoryModel(
      id: historyRef.id,
      orderId: orderId,
      fromStatus: previous.status,
      toStatus: newStatus,
      changedBy: FirebaseAuth.instance.currentUser?.uid ?? 'system',
      changedAt: DateTime.now(),
      note: note,
    );

    final batch = _firestore.batch();
    batch.update(orderRef, {'status': newStatus.name});
    batch.set(historyRef, history.toJson());
    await batch.commit();
    await _logService.record(
      action: 'Changed order ${previous.orderNumber} from ${previous.status.name} to ${newStatus.name}',
      targetType: 'order',
      targetId: orderId,
    );
  }

  Future<void> createReturnRequest({
    required String orderId,
    required List<String> itemIds,
    required String reason,
    required String condition,
    required String refundMethod,
    required double refundAmount,
    String requestType = 'return',
    String note = '',
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final orderRef = _firestore.collection('orders').doc(orderId);
    final requestRef = orderRef.collection('return_requests').doc();
    final request = OrderReturnRequestModel(
      id: requestRef.id,
      orderId: orderId,
      userId: uid,
      itemIds: itemIds,
      reason: reason,
      condition: condition,
      refundMethod: refundMethod,
      refundAmount: refundAmount,
      requestType: requestType,
      note: note,
      createdAt: DateTime.now(),
    );

    await requestRef.set(request.toJson());
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void clearAllOrders() {
    _orders.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
