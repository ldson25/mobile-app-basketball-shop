import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

enum ProductCategory {
  footwear,
  apparel,
  equipment,
}

class ProductModel {
  final String id;
  final String name;
  final String price;
  final String imageAsset;
  final String? imageUrl;
  final String? imagePublicId;
  final ProductCategory category;
  final String optionLabel;
  final Map<String, int> optionStock;
  final String badge;
  final bool isNewArrival;
  final bool isMemberExclusive;
  final bool isBestSeller;
  final bool isSignatureSeries;
  final bool isActive;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageAsset,
    this.imageUrl,
    this.imagePublicId,
    required this.category,
    required this.optionLabel,
    required this.optionStock,
    this.badge = '',
    this.isNewArrival = false,
    this.isMemberExclusive = false,
    this.isBestSeller = false,
    this.isSignatureSeries = false,
    this.isActive = true,
  });

  int get stockQuantity {
    return optionStock.values.fold(0, (total, value) => total + value);
  }

  List<String> get options => optionStock.keys.toList();

  bool get hasOptions => !(options.length == 1 && options.first == 'Default');

  String get badgeText {
    if (badge.isNotEmpty) return badge;
    if (isSignatureSeries) return 'Signature series';
    if (isNewArrival) return 'New arrival';
    if (isMemberExclusive) return 'Member exclusive';
    if (isBestSeller) return 'Best seller';
    return '';
  }

  Color get badgeColor {
    if (isSignatureSeries) return AppColors.neon;
    if (isNewArrival) return AppColors.textSecondary;
    if (isMemberExclusive) return AppColors.neon;
    if (isBestSeller) return AppColors.textSecondary;
    return AppColors.neon;
  }

  String get specWeight {
    switch (category) {
      case ProductCategory.footwear:
        return '340G';
      case ProductCategory.apparel:
        return 'Light';
      case ProductCategory.equipment:
        return 'Standard';
    }
  }

  String get specFeature {
    switch (category) {
      case ProductCategory.footwear:
        return 'Cushion';
      case ProductCategory.apparel:
        return 'Breathable';
      case ProductCategory.equipment:
        return 'Durable';
    }
  }

  String get specMaterial {
    switch (category) {
      case ProductCategory.footwear:
        return 'ARMOR-M';
      case ProductCategory.apparel:
        return 'Poly knit';
      case ProductCategory.equipment:
        return 'Training grade';
    }
  }

  double get priceValue {
    final normalized = price.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? price,
    String? imageAsset,
    String? imageUrl,
    String? imagePublicId,
    ProductCategory? category,
    String? optionLabel,
    Map<String, int>? optionStock,
    String? badge,
    bool? isNewArrival,
    bool? isMemberExclusive,
    bool? isBestSeller,
    bool? isSignatureSeries,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePublicId: imagePublicId ?? this.imagePublicId,
      category: category ?? this.category,
      optionLabel: optionLabel ?? this.optionLabel,
      optionStock: optionStock ?? this.optionStock,
      badge: badge ?? this.badge,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isMemberExclusive: isMemberExclusive ?? this.isMemberExclusive,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isSignatureSeries: isSignatureSeries ?? this.isSignatureSeries,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'priceValue': priceValue,
      'imageAsset': imageAsset,
      'imageUrl': imageUrl,
      'imagePublicId': imagePublicId,
      'category': category.name,
      'optionLabel': optionLabel,
      'optionStock': optionStock,
      'badge': badge,
      'isNewArrival': isNewArrival,
      'isMemberExclusive': isMemberExclusive,
      'isBestSeller': isBestSeller,
      'isSignatureSeries': isSignatureSeries,
      'isActive': isActive,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stock = <String, int>{};
    final rawStock = json['optionStock'];
    if (rawStock is Map) {
      for (final entry in rawStock.entries) {
        final value = entry.value;
        stock[entry.key.toString()] = value is int
            ? value
            : int.tryParse(value.toString()) ?? 0;
      }
    }

    final categoryName = json['category'] as String?;
    return ProductModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      imageAsset: (json['imageAsset'] ?? '').toString(),
      imageUrl: json['imageUrl'] as String?,
      imagePublicId: json['imagePublicId'] as String?,
      category: ProductCategory.values.firstWhere(
        (category) => category.name == categoryName,
        orElse: () => ProductCategory.footwear,
      ),
      optionLabel: (json['optionLabel'] ?? 'Option').toString(),
      optionStock: stock,
      badge: (json['badge'] ?? '').toString(),
      isNewArrival: json['isNewArrival'] == true,
      isMemberExclusive: json['isMemberExclusive'] == true,
      isBestSeller: json['isBestSeller'] == true,
      isSignatureSeries: json['isSignatureSeries'] == true,
      isActive: json['isActive'] != false,
    );
  }
}

class ProductData {
  static const Map<String, int> _shoeStock = {
    '8': 3,
    '9': 4,
    '10': 5,
    '11': 3,
    '12': 2,
    '13': 1,
  };

  static const Map<String, int> _apparelStock = {
    'S': 6,
    'M': 10,
    'L': 12,
    'XL': 8,
  };

  static final List<ProductModel> footwearProducts = [
    ProductModel(
      id: '1',
      name: 'Hypervolt v1',
      price: '4.500.000d',
      imageAsset: 'assets/images/products/hypervolt_v1.webp',
      imagePublicId: 'products/hypervolt_v1',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: _shoeStock,
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '2',
      name: 'Gravity Shift',
      price: '4.125.000d',
      imageAsset: 'assets/images/products/gravity_shift.webp',
      imagePublicId: 'products/gravity_shift',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'8': 2, '9': 3, '10': 4, '11': 2, '12': 1},
      isNewArrival: true,
    ),
    ProductModel(
      id: '3',
      name: 'Apex Core',
      price: '5.250.000d',
      imageAsset: 'assets/images/products/apex_core.webp',
      imagePublicId: 'products/apex_core',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'8': 1, '9': 1, '10': 3, '11': 2, '12': 1},
      isMemberExclusive: true,
    ),
    ProductModel(
      id: '4',
      name: 'Zenith Pro',
      price: '3.500.000d',
      imageAsset: 'assets/images/products/zenith_pro.webp',
      imagePublicId: 'products/zenith_pro',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'8': 4, '9': 6, '10': 8, '11': 7, '12': 4, '13': 2},
      isBestSeller: true,
    ),
    ProductModel(
      id: '5',
      name: 'Velocity X',
      price: '4.875.000d',
      imageAsset: 'assets/images/products/velocity_x.webp',
      imagePublicId: 'products/velocity_x',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'9': 1, '10': 2, '11': 2, '12': 1},
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '6',
      name: 'Phantom Elite',
      price: '5.625.000d',
      imageAsset: 'assets/images/products/phantom_elite.webp',
      imagePublicId: 'products/phantom_elite',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'8': 2, '9': 2, '10': 4, '11': 3, '12': 3},
      isNewArrival: true,
    ),
    ProductModel(
      id: '7',
      name: 'Ignite Pro',
      price: '3.975.000d',
      imageAsset: 'assets/images/products/ignite_pro.jpg',
      imagePublicId: 'products/ignite_pro',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'8': 1, '9': 2, '10': 3, '11': 2, '12': 1},
      isMemberExclusive: true,
    ),
    ProductModel(
      id: '8',
      name: 'Thunder Strike',
      price: '4.725.000d',
      imageAsset: 'assets/images/products/thunder_strike.jpg',
      imagePublicId: 'products/thunder_strike',
      category: ProductCategory.footwear,
      optionLabel: 'Size giay (US)',
      optionStock: {'8': 3, '9': 4, '10': 5, '11': 5, '12': 3, '13': 2},
      isBestSeller: true,
    ),
  ];

  static final List<ProductModel> apparelProducts = [
    ProductModel(
      id: '9',
      name: 'Kinetic Jersey',
      price: '2.225.000d',
      imageAsset: 'assets/images/products/kinetic_elite_jersey.webp',
      imagePublicId: 'products/kinetic_elite_jersey',
      category: ProductCategory.apparel,
      optionLabel: 'Size ao',
      optionStock: {'S': 8, 'M': 12, 'L': 14, 'XL': 6},
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '10',
      name: 'Compression Tee',
      price: '1.125.000d',
      imageAsset: 'assets/images/products/compression_tee.webp',
      imagePublicId: 'products/compression_tee',
      category: ProductCategory.apparel,
      optionLabel: 'Size ao',
      optionStock: _apparelStock,
      isNewArrival: true,
    ),
    ProductModel(
      id: '11',
      name: 'Elite Shorts',
      price: '1.625.000d',
      imageAsset: 'assets/images/products/elite_shorts.jpg',
      imagePublicId: 'products/elite_shorts',
      category: ProductCategory.apparel,
      optionLabel: 'Size quan',
      optionStock: {'S': 4, 'M': 5, 'L': 5, 'XL': 2},
      isMemberExclusive: true,
    ),
    ProductModel(
      id: '12',
      name: 'Warmup Hoodie',
      price: '3.000.000d',
      imageAsset: 'assets/images/products/warmup_hoodie.webp',
      imagePublicId: 'products/warmup_hoodie',
      category: ProductCategory.apparel,
      optionLabel: 'Size ao',
      optionStock: {'S': 2, 'M': 3, 'L': 4, 'XL': 2},
      isBestSeller: true,
    ),
  ];

  static final List<ProductModel> equipmentProducts = [
    ProductModel(
      id: '13',
      name: 'Pro Basketball',
      price: '1.375.000d',
      imageAsset: 'assets/images/products/pro_basketball.png',
      imagePublicId: 'products/pro_basketball',
      category: ProductCategory.equipment,
      optionLabel: 'Size bong',
      optionStock: {'Size 6': 12, 'Size 7': 23},
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '14',
      name: 'Training Cones',
      price: '625.000d',
      imageAsset: 'assets/images/products/training_cones.jpg',
      imagePublicId: 'products/training_cones',
      category: ProductCategory.equipment,
      optionLabel: 'Phan loai',
      optionStock: {'Bo 12 cone': 50},
      isNewArrival: true,
    ),
    ProductModel(
      id: '15',
      name: 'Resistance Bands',
      price: '875.000d',
      imageAsset: 'assets/images/products/resistance_bands.webp',
      imagePublicId: 'products/resistance_bands',
      category: ProductCategory.equipment,
      optionLabel: 'Muc khang luc',
      optionStock: {'Nhe': 7, 'Trung binh': 8, 'Nang': 5},
      isMemberExclusive: true,
    ),
  ];

  static List<ProductModel> get allProducts => [
        ...footwearProducts,
        ...apparelProducts,
        ...equipmentProducts,
      ];

  static List<ProductModel> getProductsByCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'footwear':
        return footwearProducts;
      case 'apparel':
        return apparelProducts;
      case 'equipment':
        return equipmentProducts;
      default:
        return footwearProducts;
    }
  }
}
