import 'package:flutter/material.dart';
import 'cart_service.dart';
import 'order_service.dart';


class CheckoutService {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();

  // Xử lý checkout
  Future<bool> processCheckout({
    required String shippingAddress,
    required String phoneNumber,
    required double shippingCost,
    double discount = 0,
    required String paymentMethod,
    required String customerName,
    required String shippingMethod,
    String? voucherCode,
  }) async {
    try {
      // Lấy các items đã chọn từ giỏ hàng
      final selectedItems = _cartService.selectedItems;
      
      if (selectedItems.isEmpty) {
        return false;
      }

      // Tính toán tổng tiền
      final subtotal = _cartService.selectedTotalAmount;
      final total = subtotal + shippingCost - discount;

      // Tạo đơn hàng
      _orderService.createOrder(
        items: selectedItems,
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

      // Xóa các items đã chọn khỏi giỏ hàng
      _cartService.removeCheckedItems();

      return true;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return false;
    }
  }
}
