import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ProductModel {
  final String id;
  final String name;
  final String price;
  final String imageAsset; 
  final String badge;
  final bool isNewArrival;
  final bool isMemberExclusive;
  final bool isBestSeller;
  final bool isSignatureSeries;
  final int stockQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageAsset, 
    this.badge = '',
    this.isNewArrival = false,
    this.isMemberExclusive = false,
    this.isBestSeller = false,
    this.isSignatureSeries = false,
    this.stockQuantity = 24,
  });

  String get badgeText {
    if (isSignatureSeries) return 'Signature Series';
    if (isNewArrival) return 'New Arrival';
    if (isMemberExclusive) return 'Member Exclusive';
    if (isBestSeller) return 'Best Seller';
    return badge;
  }

  Color get badgeColor {
    if (isSignatureSeries) return AppColors.neon;
    if (isNewArrival) return AppColors.textSecondary;
    if (isMemberExclusive) return AppColors.neon;
    if (isBestSeller) return AppColors.textSecondary;
    return AppColors.neon;
  }
}
class ProductData {
  // Sản phẩm cho Footwear category
  static final List<ProductModel> footwearProducts = [
    ProductModel(
      id: '1',
      name: 'Hypervolt v1',
      price: '\$180.00',
      imageAsset: 'assets/images/products/hypervolt_v1.webp',
      isSignatureSeries: true,
      stockQuantity: 18,
    ),
    ProductModel(
      id: '2',
      name: 'Gravity Shift',
      price: '\$165.00',
      imageAsset: 'assets/images/products/gravity_shift.webp',
      isNewArrival: true,
      stockQuantity: 12,
    ),
    ProductModel(
      id: '3',
      name: 'Apex Core',
      price: '\$210.00',
      imageAsset: 'assets/images/products/apex_core.webp',
      isMemberExclusive: true,
      stockQuantity: 8,
    ),
    ProductModel(
      id: '4',
      name: 'Zenith Pro',
      price: '\$140.00',
      imageAsset: 'assets/images/products/zenith_pro.webp',
      isBestSeller: true,
      stockQuantity: 31,
    ),
    ProductModel(
      id: '5',
      name: 'Velocity X',
      price: '\$195.00',
      imageAsset: 'assets/images/products/velocity_x.webp',
      isSignatureSeries: true,
      stockQuantity: 6,
    ),
    ProductModel(
      id: '6',
      name: 'Phantom Elite',
      price: '\$225.00',
      imageAsset: 'assets/images/products/phantom_elite.webp',
      isNewArrival: true,
      stockQuantity: 14,
    ),
    ProductModel(
      id: '7',
      name: 'Ignite Pro',
      price: '\$159.00',
      imageAsset: 'assets/images/products/ignite_pro.jpg',
      isMemberExclusive: true,
      stockQuantity: 9,
    ),
    ProductModel(
      id: '8',
      name: 'Thunder Strike',
      price: '\$189.00',
      imageAsset: 'assets/images/products/thunder_strike.jpg',
      isBestSeller: true,
      stockQuantity: 22,
    ),
  ];

  // Sản phẩm cho Apparel category
  static final List<ProductModel> apparelProducts = [
    ProductModel(
      id: '9',
      name: 'Kinetic Jersey',
      price: '\$89.00',
      imageAsset: 'assets/images/products/kinetic_elite_jersey.webp',
      isSignatureSeries: true,
      stockQuantity: 40,
    ),
    ProductModel(
      id: '10',
      name: 'Compression Tee',
      price: '\$45.00',
      imageAsset: 'assets/images/products/compression_tee.webp',
      isNewArrival: true,
      stockQuantity: 28,
    ),
    ProductModel(
      id: '11',
      name: 'Elite Shorts',
      price: '\$65.00',
      imageAsset: 'assets/images/products/elite_shorts.jpg',
      isMemberExclusive: true,
      stockQuantity: 16,
    ),
    ProductModel(
      id: '12',
      name: 'Warmup Hoodie',
      price: '\$120.00',
      imageAsset: 'assets/images/products/warmup_hoodie.webp',
      isBestSeller: true,
      stockQuantity: 11,
    ),
  ];

  // Sản phẩm cho Equipment category
  static final List<ProductModel> equipmentProducts = [
    ProductModel(
      id: '13',
      name: 'Pro Basketball',
      price: '\$55.00',
      imageAsset: 'assets/images/products/pro_basketball.png',
      isSignatureSeries: true,
      stockQuantity: 35,
    ),
    ProductModel(
      id: '14',
      name: 'Training Cones',
      price: '\$25.00',
      imageAsset: 'assets/images/products/training_cones.jpg',
      isNewArrival: true,
      stockQuantity: 50,
    ),
    ProductModel(
      id: '15',
      name: 'Resistance Bands',
      price: '\$35.00',
      imageAsset: 'assets/images/products/resistance_bands.webp',
      isMemberExclusive: true,
      stockQuantity: 20,
    ),
  ];

  // Lấy sản phẩm theo category
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
