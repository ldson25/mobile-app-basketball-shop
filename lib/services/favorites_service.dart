import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;

  FavoritesService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _favoritesSubscription?.cancel();
      _favorites = [];
      if (user == null) {
        notifyListeners();
        return;
      }
      _subscribeToFavorites(user.uid);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _favoritesSubscription;

  List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => List.unmodifiable(_favorites);

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _favoritesRef {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  void _subscribeToFavorites(String uid) {
    _favoritesSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      _favorites = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson({
          ...data,
          'id': data['id'] ?? doc.id,
        });
      }).toList();
      notifyListeners();
    });
  }

  void addToFavorites(ProductModel product) {
    if (!_favorites.any((item) => item.id == product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
    _favoritesRef?.doc(product.id).set(product.toJson());
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((item) => item.id == productId);
    notifyListeners();
    _favoritesRef?.doc(productId).delete();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.id == productId);
  }

  void toggleFavorite(ProductModel product) {
    if (isFavorite(product.id)) {
      removeFromFavorites(product.id);
    } else {
      addToFavorites(product);
    }
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}
