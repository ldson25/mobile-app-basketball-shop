import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _cartSubscription?.cancel();
      _cartItems = [];
      if (user == null) {
        notifyListeners();
        return;
      }
      _subscribeToCart(user.uid);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _cartSubscription;

  List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _cartRef {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('cart');
  }

  void _subscribeToCart(String uid) {
    _cartSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .listen((snapshot) {
      _cartItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return CartItemModel.fromJson({
          ...data,
          'id': data['id'] ?? doc.id,
        });
      }).toList();
      notifyListeners();
    });
  }

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

    CartItemModel nextItem;
    if (existingIndex != -1) {
      final current = _cartItems[existingIndex];
      nextItem = current.copyWith(
        quantity: (current.quantity + safeQuantity).clamp(1, availableStock).toInt(),
      );
      _cartItems[existingIndex] = nextItem;
    } else {
      nextItem = CartItemModel(
        id: cartId,
        productId: product.id,
        imagePath: product.imageAsset,
        imageUrl: product.imageUrl,
        title: product.name,
        size: option,
        price: _parsePrice(product.price),
        quantity: safeQuantity,
      );
      _cartItems.add(nextItem);
    }

    notifyListeners();
    _cartRef?.doc(cartId).set(nextItem.toJson());
  }

  void removeFromCart(String id, {String? size}) {
    final idsToRemove = _cartItems
        .where((item) => size == null ? item.id == id : item.id == id && item.size == size)
        .map((item) => item.id)
        .toList();
    _cartItems.removeWhere((item) => idsToRemove.contains(item.id));
    notifyListeners();
    for (final itemId in idsToRemove) {
      _cartRef?.doc(itemId).delete();
    }
  }

  void updateQuantity(String id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index == -1) return;

    if (quantity <= 0) {
      final removedId = _cartItems[index].id;
      _cartItems.removeAt(index);
      notifyListeners();
      _cartRef?.doc(removedId).delete();
      return;
    }

    _cartItems[index].quantity = quantity;
    notifyListeners();
    _cartRef?.doc(id).set(_cartItems[index].toJson());
  }

  void toggleCheck(String id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index == -1) return;

    _cartItems[index].isChecked = !_cartItems[index].isChecked;
    notifyListeners();
    _cartRef?.doc(id).set(_cartItems[index].toJson());
  }

  void removeCheckedItems() {
    final checkedIds = _cartItems.where((item) => item.isChecked).map((item) => item.id).toList();
    _cartItems.removeWhere((item) => item.isChecked);
    notifyListeners();
    for (final id in checkedIds) {
      _cartRef?.doc(id).delete();
    }
  }

  void clearCart() {
    final ids = _cartItems.map((item) => item.id).toList();
    _cartItems.clear();
    notifyListeners();
    for (final id in ids) {
      _cartRef?.doc(id).delete();
    }
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

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}
