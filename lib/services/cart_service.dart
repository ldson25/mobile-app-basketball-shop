import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(ProductModel product, String size) {
    // Kiểm tra sản phẩm đã có trong giỏ chưa (cùng id và size)
    final existingIndex = _cartItems.indexWhere(
      (item) => item.id == product.id && item.size == size,
    );

    if (existingIndex != -1) {
      // Nếu đã có, tăng số lượng
      _cartItems[existingIndex].quantity++;
    } else {
      // Nếu chưa có, thêm mới
      _cartItems.add(
        CartItemModel(
          id: product.id,
          imagePath: product.imageAsset,
          title: product.name,
          size: size,
          price: double.parse(product.price.replaceAll('\$', '')),
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(String id, {String? size}) {
    if (size != null) {
      // Xóa theo cả id và size
      _cartItems.removeWhere((item) => item.id == id && item.size == size);
    } else {
      // Xóa tất cả sản phẩm có id đó
      _cartItems.removeWhere((item) => item.id == id);
    }
    notifyListeners();
  }

  // Cập nhật số lượng sản phẩm
  void updateQuantity(String id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        // Nếu quantity <= 0 thì xóa sản phẩm
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  // Toggle trạng thái checked của sản phẩm
  void toggleCheck(String id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index].isChecked = !_cartItems[index].isChecked;
      notifyListeners();
    }
  }

  // Xóa tất cả sản phẩm đã chọn
  void removeCheckedItems() {
    _cartItems.removeWhere((item) => item.isChecked);
    notifyListeners();
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Tổng số lượng sản phẩm trong giỏ
  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Tổng tiền tất cả sản phẩm
  double get totalAmount {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  // Tổng tiền các sản phẩm đã chọn
  double get selectedTotalAmount {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.isChecked ? item.price * item.quantity : 0),
    );
  }

  // Danh sách sản phẩm đã chọn
  List<CartItemModel> get selectedItems {
    return _cartItems.where((item) => item.isChecked).toList();
  }
}