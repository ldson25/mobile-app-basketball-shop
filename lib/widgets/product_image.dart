import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/product_model.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final ProductModel product;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl;
    if (url != null && url.trim().isNotEmpty) {
      return Image.network(
        _optimizedCloudinaryUrl(url),
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.low,
        cacheWidth: _cacheDimension(width),
        cacheHeight: _cacheDimension(height),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _loadingFallback();
        },
        errorBuilder: (context, error, stackTrace) => _assetFallback(),
      );
    }
    return _assetFallback();
  }

  int? _cacheDimension(double? value) {
    if (value == null || value <= 0) return 900;
    return (value * 2).clamp(160, 1200).round();
  }

  String _optimizedCloudinaryUrl(String url) {
    final trimmed = url.trim();
    if (!trimmed.contains('res.cloudinary.com') ||
        !trimmed.contains('/image/upload/')) {
      return trimmed;
    }
    if (trimmed.contains('/image/upload/f_auto,')) {
      return trimmed;
    }
    return trimmed.replaceFirst(
      '/image/upload/',
      '/image/upload/f_auto,q_auto,w_900,c_limit/',
    );
  }

  Widget _assetFallback() {
    if (product.imageAsset.trim().isEmpty) {
      return _emptyFallback();
    }
    return Image.asset(
      product.imageAsset,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.low,
      errorBuilder: (context, error, stackTrace) => _emptyFallback(),
    );
  }

  Widget _emptyFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface2,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _loadingFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface2,
      child: Icon(
        Icons.image_outlined,
        color: AppColors.textMuted,
      ),
    );
  }
}
