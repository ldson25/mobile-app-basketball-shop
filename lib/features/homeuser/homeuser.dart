import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/product_model.dart';
import '../cart/mycart.dart';
import '../products/presentation/product_detail_screen.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({super.key, required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _HomeAppBar(onMenuTap: onMenuTap),
      body: const HomeBody(),
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
            const Column(
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
                  'PERFORMANCE STORE',
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
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const FilterSection(),
          const SizedBox(height: 18),
          SeasonalDropsHero(
            product: ProductData.footwearProducts.first,
          ),
          const SizedBox(height: 48),
          _ProductRail(
            eyebrow: 'Vua ra mat',
            title: 'Hang moi ve',
            products: [
              ProductData.footwearProducts[1],
              ProductData.apparelProducts[0],
              ProductData.footwearProducts[5],
            ],
          ),
          const SizedBox(height: 48),
          const EditorialBanner(),
          const SizedBox(height: 48),
          _ProductRail(
            eyebrow: 'Thinh hanh',
            title: 'Ban chay nhat',
            compact: true,
            products: [
              ProductData.footwearProducts[3],
              ProductData.footwearProducts[7],
              ProductData.equipmentProducts[0],
            ],
          ),
          const SizedBox(height: 112),
        ],
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    const filters = [
      ('Tat ca', true),
      ('Giay', false),
      ('Ao dau', false),
      ('Phu kien', false),
      ('Tap luyen', false),
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: AppSizes.pageHorizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return _FilterChip(label: filter.$1, isSelected: filter.$2);
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.neon : AppColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected ? AppColors.neon : AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isSelected ? AppColors.background : AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class SeasonalDropsHero extends StatelessWidget {
  const SeasonalDropsHero({super.key, required this.product});

  final ProductModel product;

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
                Image.asset(
                  product.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.surface2,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textMuted,
                      size: 42,
                    ),
                  ),
                ),
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
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 46, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '${product.stockQuantity} items in stock',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: () => _openDetail(context, product),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('SHOP NOW'),
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
  const _ProductRail({
    required this.eyebrow,
    required this.title,
    required this.products,
    this.compact = false,
  });

  final String eyebrow;
  final String title;
  final List<ProductModel> products;
  final bool compact;

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
              return _ProductCard(product: products[index], compact: compact);
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
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
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
              'VIEW ALL',
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
  const _ProductCard({required this.product, required this.compact});

  final ProductModel product;
  final bool compact;

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
                  Image.asset(
                    product.imageAsset,
                    width: width,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: width,
                      height: imageHeight,
                      color: AppColors.surface2,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
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
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.stockQuantity} left',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
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
                  style: const TextStyle(
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
  const EditorialBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ProductData.apparelProducts.first;

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
                Image.asset(
                  product.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.surface2,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.34)),
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NeonTag(label: 'Street series'),
                      SizedBox(height: 14),
                      Text(
                        'OWN THE\nASPHALT',
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
                        'Tap to view the featured apparel drop.',
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
        style: const TextStyle(
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
