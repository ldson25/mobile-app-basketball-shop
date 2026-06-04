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
  final ProductCategory category;
  final String optionLabel;
  final Map<String, int> optionStock;
  final String badge;
  final bool isNewArrival;
  final bool isMemberExclusive;
  final bool isBestSeller;
  final bool isSignatureSeries;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageAsset,
    required this.category,
    required this.optionLabel,
    required this.optionStock,
    this.badge = '',
    this.isNewArrival = false,
    this.isMemberExclusive = false,
    this.isBestSeller = false,
    this.isSignatureSeries = false,
  });

  int get stockQuantity {
    return optionStock.values.fold(0, (total, value) => total + value);
  }

  List<String> get options => optionStock.keys.toList();

  bool get hasOptions => !(options.length == 1 && options.first == 'Mặc định');

  String get badgeText {
    if (isSignatureSeries) return 'Dòng đặc biệt';
    if (isNewArrival) return 'Hàng mới';
    if (isMemberExclusive) return 'Dành cho member';
    if (isBestSeller) return 'Bán chạy';
    return badge;
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
        return 'Nhẹ';
      case ProductCategory.equipment:
        return 'Tiêu chuẩn';
    }
  }

  String get specFeature {
    switch (category) {
      case ProductCategory.footwear:
        return 'Đệm êm';
      case ProductCategory.apparel:
        return 'Thoáng khí';
      case ProductCategory.equipment:
        return 'Bền bỉ';
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
      price: '4.500.000đ',
      imageAsset: 'assets/images/products/hypervolt_v1.webp',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: _shoeStock,
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '2',
      name: 'Gravity Shift',
      price: '4.125.000đ',
      imageAsset: 'assets/images/products/gravity_shift.webp',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'8': 2, '9': 3, '10': 4, '11': 2, '12': 1},
      isNewArrival: true,
    ),
    ProductModel(
      id: '3',
      name: 'Apex Core',
      price: '5.250.000đ',
      imageAsset: 'assets/images/products/apex_core.webp',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'8': 1, '9': 1, '10': 3, '11': 2, '12': 1},
      isMemberExclusive: true,
    ),
    ProductModel(
      id: '4',
      name: 'Zenith Pro',
      price: '3.500.000đ',
      imageAsset: 'assets/images/products/zenith_pro.webp',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'8': 4, '9': 6, '10': 8, '11': 7, '12': 4, '13': 2},
      isBestSeller: true,
    ),
    ProductModel(
      id: '5',
      name: 'Velocity X',
      price: '4.875.000đ',
      imageAsset: 'assets/images/products/velocity_x.webp',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'9': 1, '10': 2, '11': 2, '12': 1},
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '6',
      name: 'Phantom Elite',
      price: '5.625.000đ',
      imageAsset: 'assets/images/products/phantom_elite.webp',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'8': 2, '9': 2, '10': 4, '11': 3, '12': 3},
      isNewArrival: true,
    ),
    ProductModel(
      id: '7',
      name: 'Ignite Pro',
      price: '3.975.000đ',
      imageAsset: 'assets/images/products/ignite_pro.jpg',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'8': 1, '9': 2, '10': 3, '11': 2, '12': 1},
      isMemberExclusive: true,
    ),
    ProductModel(
      id: '8',
      name: 'Thunder Strike',
      price: '4.725.000đ',
      imageAsset: 'assets/images/products/thunder_strike.jpg',
      category: ProductCategory.footwear,
      optionLabel: 'Size giày (US)',
      optionStock: {'8': 3, '9': 4, '10': 5, '11': 5, '12': 3, '13': 2},
      isBestSeller: true,
    ),
  ];

  static final List<ProductModel> apparelProducts = [
    ProductModel(
      id: '9',
      name: 'Kinetic Jersey',
      price: '2.225.000đ',
      imageAsset: 'assets/images/products/kinetic_elite_jersey.webp',
      category: ProductCategory.apparel,
      optionLabel: 'Size áo',
      optionStock: {'S': 8, 'M': 12, 'L': 14, 'XL': 6},
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '10',
      name: 'Compression Tee',
      price: '1.125.000đ',
      imageAsset: 'assets/images/products/compression_tee.webp',
      category: ProductCategory.apparel,
      optionLabel: 'Size áo',
      optionStock: _apparelStock,
      isNewArrival: true,
    ),
    ProductModel(
      id: '11',
      name: 'Elite Shorts',
      price: '1.625.000đ',
      imageAsset: 'assets/images/products/elite_shorts.jpg',
      category: ProductCategory.apparel,
      optionLabel: 'Size quần',
      optionStock: {'S': 4, 'M': 5, 'L': 5, 'XL': 2},
      isMemberExclusive: true,
    ),
    ProductModel(
      id: '12',
      name: 'Warmup Hoodie',
      price: '3.000.000đ',
      imageAsset: 'assets/images/products/warmup_hoodie.webp',
      category: ProductCategory.apparel,
      optionLabel: 'Size áo',
      optionStock: {'S': 2, 'M': 3, 'L': 4, 'XL': 2},
      isBestSeller: true,
    ),
  ];

  static final List<ProductModel> equipmentProducts = [
    ProductModel(
      id: '13',
      name: 'Pro Basketball',
      price: '1.375.000đ',
      imageAsset: 'assets/images/products/pro_basketball.png',
      category: ProductCategory.equipment,
      optionLabel: 'Size bóng',
      optionStock: {'Size 6': 12, 'Size 7': 23},
      isSignatureSeries: true,
    ),
    ProductModel(
      id: '14',
      name: 'Training Cones',
      price: '625.000đ',
      imageAsset: 'assets/images/products/training_cones.jpg',
      category: ProductCategory.equipment,
      optionLabel: 'Phân loại',
      optionStock: {'Bộ 12 cone': 50},
      isNewArrival: true,
    ),
    ProductModel(
      id: '15',
      name: 'Resistance Bands',
      price: '875.000đ',
      imageAsset: 'assets/images/products/resistance_bands.webp',
      category: ProductCategory.equipment,
      optionLabel: 'Mức kháng lực',
      optionStock: {'Nhẹ': 7, 'Trung bình': 8, 'Nặng': 5},
      isMemberExclusive: true,
    ),
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
