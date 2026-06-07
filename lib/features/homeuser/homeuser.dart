import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/product_model.dart';
import '../../services/banner_service.dart';
import '../../services/product_service.dart';
import '../../widgets/product_image.dart';
import '../cart/mycart.dart';
import '../products/presentation/product_detail_screen.dart';

class HomeUserScreen extends StatelessWidget {
  final VoidCallback onMenuTap;
  final Future<bool> Function() onRequireAuth;

  const HomeUserScreen({
    super.key,
    required this.onMenuTap,
    required this.onRequireAuth,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Force rebuild on theme change
    return Scaffold(
      appBar: _HomeAppBar(onMenuTap: onMenuTap),
      body: HomeBody(onRequireAuth: onRequireAuth),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Row(
          children: [
            _CircleIconButton(icon: Icons.menu_rounded, onTap: onMenuTap),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'KINETIC',
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppColors.neon,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'CỬA HÀNG THỂ THAO',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _CircleIconButton(
              icon: Icons.shopping_bag_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border.withOpacity(0.35)),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final Future<bool> Function() onRequireAuth;

  const HomeBody({super.key, required this.onRequireAuth});

  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final footwear = productService.getProductsByCategory('footwear');
    final apparel = productService.getProductsByCategory('apparel');
    final equipment = productService.getProductsByCategory('equipment');

    if (footwear.isEmpty || apparel.isEmpty || equipment.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.neon),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
          const SizedBox(height: 18),
          SeasonalDropsHero(
            product: footwear.first,
            onRequireAuth: onRequireAuth,
          ),
          const SizedBox(height: 48),
          _ProductRail(
            eyebrow: 'Vừa ra mắt',
            title: 'Hàng mới về',
            products: [
              if (footwear.length > 1) footwear[1],
              apparel.first,
              if (footwear.length > 5) footwear[5],
            ],
            onRequireAuth: onRequireAuth,
          ),
          const SizedBox(height: 48),
          FirestoreEditorialBanner(onRequireAuth: onRequireAuth),
          const SizedBox(height: 48),
          _ProductRail(
            eyebrow: 'Thịnh hành',
            title: 'Bán chạy nhất',
            compact: true,
            products: [
              if (footwear.length > 3) footwear[3],
              if (footwear.length > 7) footwear[7],
              equipment.first,
            ],
            onRequireAuth: onRequireAuth,
          ),
          const SizedBox(height: 112),
      ],
    );
  }
}

class SeasonalDropsHero extends StatelessWidget {
  final ProductModel product;
  final Future<bool> Function() onRequireAuth;

  const SeasonalDropsHero({
    super.key,
    required this.product,
    required this.onRequireAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.pageHorizontal,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        onTap: () => _openDetail(context, product),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          child: SizedBox(
            height: 500,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(product: product, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.background.withOpacity(0.96),
                        AppColors.background.withOpacity(0.42),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NeonTag(label: product.badgeText),
                      const SizedBox(height: 16),
                      Text(
                        product.name.toUpperCase(),
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontSize: 46,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Còn ${product.stockQuantity} sản phẩm',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: () => _openDetail(context, product),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('MUA NGAY'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neon,
                          foregroundColor: AppColors.background,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductRail extends StatelessWidget {
  final String eyebrow;
  final String title;
  final List<ProductModel> products;
  final bool compact;
  final Future<bool> Function() onRequireAuth;

  const _ProductRail({
    required this.eyebrow,
    required this.title,
    required this.products,
    this.compact = false,
    required this.onRequireAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(eyebrow: eyebrow, title: title),
        const SizedBox(height: 18),
        SizedBox(
          height: compact ? 356 : 438,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: AppSizes.pageHorizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              return _ProductCard(
                product: products[index],
                compact: compact,
                onRequireAuth: onRequireAuth,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.pageHorizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              'XEM TẤT CẢ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool compact;
  final Future<bool> Function() onRequireAuth;

  const _ProductCard({
    required this.product,
    required this.compact,
    required this.onRequireAuth,
  });

  @override
  Widget build(BuildContext context) {
    final width = compact ? 246.0 : 274.0;
    final imageHeight = compact ? 198.0 : 310.0;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      onTap: () => _openDetail(context, product),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              child: Stack(
                children: [
                  ProductImage(
                    product: product,
                    width: width,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _NeonTag(label: product.badgeText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Còn ${product.stockQuantity} sản phẩm',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  product.price,
                  style: TextStyle(
                    color: AppColors.neon,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditorialBanner extends StatelessWidget {
  final Future<bool> Function() onRequireAuth;

  const EditorialBanner({super.key, required this.onRequireAuth});

  @override
  Widget build(BuildContext context) {
    final apparel = context.watch<ProductService>().getProductsByCategory('apparel');
    if (apparel.isEmpty) return const SizedBox.shrink();
    final product = apparel.first;

    return Padding(
      padding: AppSizes.pageHorizontal,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        onTap: () => _openDetail(context, product),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          child: SizedBox(
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(product: product, fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.34)),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NeonTag(label: 'Bộ sưu tập đường phố'),
                      SizedBox(height: 14),
                      Text(
                        'LÀM CHỦ\nSÂN ĐẤU',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                          height: 0.95,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Nhấn để xem bộ trang phục nổi bật.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirestoreEditorialBanner extends StatelessWidget {
  final Future<bool> Function() onRequireAuth;

  const FirestoreEditorialBanner({super.key, required this.onRequireAuth});

  @override
  Widget build(BuildContext context) {
    final bannerService = context.watch<BannerService>();
    final productService = context.read<ProductService>();
    final apparel = productService.getProductsByCategory('apparel');
    if (apparel.isEmpty) return const SizedBox.shrink();

    final banner = bannerService.activeBanners.isEmpty
        ? null
        : bannerService.activeBanners.first;
    final bannerProduct = banner != null && banner.productId.isNotEmpty
        ? productService.getProductById(banner.productId)
        : null;
    final product = bannerProduct ?? apparel.first;
    final title = banner != null && banner.title.isNotEmpty
        ? banner.title
        : 'LAM CHU\nSAN DAU';
    final subtitle = banner != null && banner.subtitle.isNotEmpty
        ? banner.subtitle
        : 'Nhan de xem bo trang phuc noi bat.';

    return Padding(
      padding: AppSizes.pageHorizontal,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        onTap: () => _openDetail(context, product),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          child: SizedBox(
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(product: product, fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.34)),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NeonTag(label: banner?.title ?? 'Street series'),
                      const SizedBox(height: 14),
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                          height: 0.95,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonTag extends StatelessWidget {
  const _NeonTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.neon,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: AppColors.background,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

void _openDetail(BuildContext context, ProductModel product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}
