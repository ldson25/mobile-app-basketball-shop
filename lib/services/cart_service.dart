import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  double _parsePrice(String price) {
    final normalized = price.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  String _cartItemId(ProductModel product, String option) {
    return '${product.id}::$option';
  }

  void addToCart(ProductModel product, String option, {int quantity = 1}) {
    final availableStock = product.optionStock[option] ?? product.stockQuantity;
    final safeQuantity = quantity.clamp(1, availableStock).toInt();
    final cartId = _cartItemId(product, option);

    final existingIndex = _cartItems.indexWhere((item) => item.id == cartId);

    if (existingIndex != -1) {
      final currentQuantity = _cartItems[existingIndex].quantity;
      _cartItems[existingIndex].quantity =
          (currentQuantity + safeQuantity).clamp(1, availableStock).toInt();
    } else {
      _cartItems.add(
        CartItemModel(
          id: cartId,
          imagePath: product.imageAsset,
          title: product.name,
          size: option,
          price: _parsePrice(product.price),
          quantity: safeQuantity,
        ),
      );
    }

    notifyListeners();
  }

  void removeFromCart(String id, {String? size}) {
    _cartItems.removeWhere((item) {
      if (size == null) return item.id == id;
      return item.id == id && item.size == size;
    });
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index == -1) return;

    if (quantity <= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index].quantity = quantity;
    }
    notifyListeners();
  }

  void toggleCheck(String id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index == -1) return;

    _cartItems[index].isChecked = !_cartItems[index].isChecked;
    notifyListeners();
  }

  void removeCheckedItems() {
    _cartItems.removeWhere((item) => item.isChecked);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get selectedTotalAmount {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.isChecked ? item.price * item.quantity : 0),
    );
  }

  List<CartItemModel> get selectedItems {
    return _cartItems.where((item) => item.isChecked).toList();
  }
}
