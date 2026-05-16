import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/product_model.dart';
import '../core/constants/app_sizes.dart';
import '../features/products/presentation/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onProductTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onFavoriteTap,
    this.onAddToCart,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 250, // Giảm từ 280 xuống 250
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          GestureDetector(
            onTap: onProductTap ?? () {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: product,
                  ),
                ),
              );
            }, // Thêm onProductTap để xử lý khi người dùng nhấn vào hình ảnh
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              ),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  child: Stack(
                    children: [
                      Image.asset(
                        product.imageAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surface3,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textSecondary,
                                size: 28, // Giảm từ 32 xuống 28
                              ),
                            ),
                          );
                        },
                      ),
                      // Favorite button
                      Positioned(
                        top: 6, // Giảm từ 8 xuống 6
                        right: 6, // Giảm từ 8 xuống 6
                        child: GestureDetector(
                          onTap: onFavoriteTap,
                          child: Container(
                            width: 24, // Giảm từ 28 xuống 24
                            height: 24, // Giảm từ 28 xuống 24
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 14, // Giảm từ 16 xuống 14
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8), // Giảm từ 12 xuống 8
          // Product info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2), // Giảm từ 4 xuống 2
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.badgeText.isNotEmpty)
                  Text(
                    product.badgeText.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 7, // Giảm từ 8 xuống 7
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.neon,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 11, // Giảm từ 13 xuống 11
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3), // Giảm từ 4 xuống 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 13, // Giảm từ 15 xuống 13
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: onAddToCart,
                      child: Container(
                        width: 24, // Giảm từ 28 xuống 24
                        height: 24, // Giảm từ 28 xuống 24
                        decoration: const BoxDecoration(
                          color: AppColors.neon,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.background,
                          size: 16, // Giảm từ 18 xuống 16
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}