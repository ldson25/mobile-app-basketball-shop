import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'admin_activity_log_service.dart';

class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  ProductService._internal() {
    _subscribe();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AdminActivityLogService _logService = AdminActivityLogService();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  List<ProductModel> _products = ProductData.allProducts;
  bool _isLoading = true;
  bool _usingFallback = true;

  List<ProductModel> get products =>
      _products.where((product) => product.isActive).toList();
  List<ProductModel> get adminProducts => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  bool get usingFallback => _usingFallback;

  void _subscribe() {
    _subscription = _firestore
        .collection('products')
        .orderBy('name')
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          _products = ProductData.allProducts;
          _usingFallback = true;
        } else {
          _products = snapshot.docs.map((doc) {
            final data = doc.data();
            return ProductModel.fromJson({
              ...data,
              'id': data['id'] ?? doc.id,
            });
          }).toList();
          _usingFallback = false;
        }
        _isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        _products = ProductData.allProducts;
        _usingFallback = true;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  List<ProductModel> getProductsByCategory(String categoryName) {
    final category = categoryName.toLowerCase();
    return products.where((product) => product.category.name == category).toList();
  }

  ProductModel? getProductById(String id) {
    for (final product in _products) {
      if (product.id == id) return product;
    }
    return null;
  }

  Future<void> saveProduct(ProductModel product) async {
    final existing = getProductById(product.id);
    _upsertLocal(product);
    await _firestore.collection('products').doc(product.id).set(product.toJson());
    await _logService.record(
      action: existing == null
          ? 'Added product ${product.name}'
          : 'Updated product ${product.name}',
      targetType: 'product',
      targetId: product.id,
    );
  }

  Future<void> toggleProductVisibility(String id) async {
    final product = getProductById(id);
    if (product == null) return;
    await saveProduct(product.copyWith(isActive: !product.isActive));
    await _logService.record(
      action: product.isActive
          ? 'Hidden product ${product.name}'
          : 'Shown product ${product.name}',
      targetType: 'product',
      targetId: id,
    );
  }

  Future<void> updateStock(String id, Map<String, int> optionStock) async {
    final product = getProductById(id);
    if (product == null) return;
    await saveProduct(product.copyWith(optionStock: optionStock));
    await _logService.record(
      action: 'Updated stock for ${product.name}',
      targetType: 'product',
      targetId: id,
    );
  }

  Future<void> deleteProduct(String id) async {
    final product = getProductById(id);
    _products = _products.where((item) => item.id != id).toList();
    notifyListeners();
    await _firestore.collection('products').doc(id).delete();
    await _logService.record(
      action: 'Deleted product ${product?.name ?? id}',
      targetType: 'product',
      targetId: id,
    );
  }

  Future<void> seedDefaultProducts() async {
    final batch = _firestore.batch();
    for (final product in ProductData.allProducts) {
      final ref = _firestore.collection('products').doc(product.id);
      batch.set(ref, product.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  void _upsertLocal(ProductModel product) {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      _products = [product, ..._products];
    } else {
      final copy = [..._products];
      copy[index] = product;
      _products = copy;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
