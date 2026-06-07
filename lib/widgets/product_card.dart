import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_sizes.dart';
import '../core/theme/app_colors.dart';
import '../features/auth/presentation/login.dart';
import '../features/products/presentation/product_detail_screen.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';
import 'product_image.dart';

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
    final isFavorite = context.watch<FavoritesService>().isFavorite(product.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(color: AppColors.border.withOpacity(0.45)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onProductTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ProductImage(product: product, fit: BoxFit.contain),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: onFavoriteTap ?? () => _toggleFavorite(context),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.textPrimary,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.badgeText.isNotEmpty)
                    SizedBox(
                      height: 14,
                      child: Text(
                        product.badgeText.toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.neon,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    const SizedBox(height: 14),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onAddToCart ?? () => _addDefaultOptionToCart(context),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.neon,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.background,
                            size: 18,
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
      ),
    );
  }

  Future<bool> _requireAuth(BuildContext context) async {
    final authService = context.read<AuthService>();
    if (authService.isAuthenticated) return true;

    final shouldLogin = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn cần đăng nhập hoặc đăng ký để thực hiện chức năng này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Để sau'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );

    if (shouldLogin != true) return false;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    if (!context.mounted) return false;
    return context.read<AuthService>().isAuthenticated;
  }

  Future<void> _addDefaultOptionToCart(BuildContext context) async {
    final authed = await _requireAuth(context);
    if (!authed || !context.mounted) return;

    final option = product.options.isEmpty ? 'Default' : product.options.first;
    final stock = product.optionStock[option] ?? product.stockQuantity;
    if (stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đang hết hàng.')),
      );
      return;
    }

    context.read<CartService>().addToCart(product, option);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm ${product.name} vào giỏ hàng')),
    );
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final authed = await _requireAuth(context);
    if (!authed || !context.mounted) return;

    final service = context.read<FavoritesService>();
    final wasFavorite = service.isFavorite(product.id);
    service.toggleFavorite(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasFavorite
              ? 'Đã xóa ${product.name} khỏi yêu thích'
              : 'Đã thêm ${product.name} vào yêu thích',
        ),
      ),
    );
  }
}
