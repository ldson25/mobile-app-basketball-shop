import 'package:flutter/material.dart';
import '../models/product_model.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => _favorites;

  void addToFavorites(ProductModel product) {
    if (!_favorites.any((item) => item.id == product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((item) => item.id == productId);
    notifyListeners();
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
}