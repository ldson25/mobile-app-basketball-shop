import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../services/product_service.dart';
import '../cart/mycart.dart';
import 'results_discover_screen.dart';

class DiscoverScreen extends StatelessWidget {
  final VoidCallback onMenuTap;
  final Future<bool> Function() onRequireAuth;

  const DiscoverScreen({
    super.key,
    required this.onMenuTap,
    required this.onRequireAuth,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Force rebuild on theme change
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _CustomAppBar(onMenuTap: onMenuTap),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _SearchSection(onRequireAuth: onRequireAuth),
              const SizedBox(height: 48),
              _CategoriesSection(onRequireAuth: onRequireAuth),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;

  const _CustomAppBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(179),
        border: Border(
          bottom: BorderSide(color: AppColors.border.withAlpha(77)),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: IconButton(
                  onPressed: onMenuTap,
                  icon: Icon(Icons.menu, color: AppColors.textPrimary),
                ),
              ),
            ),
            Center(
              child: Text(
                'KHÁM PHÁ',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                  color: AppColors.neon,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.textPrimary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  final Future<bool> Function() onRequireAuth;

  const _SearchSection({required this.onRequireAuth});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface2.withAlpha(128),
        border: Border.all(color: AppColors.border.withAlpha(77)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'TÌM SẢN PHẨM',
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsDiscoverScreen(
                        categoryName: 'KẾT QUẢ TÌM KIẾM',
                        itemCount: 42,
                        searchKeyword: value,
                        onRequireAuth: onRequireAuth,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () => _showSearchFilter(context),
            child: Icon(Icons.tune, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void _showSearchFilter(BuildContext context) {
    final products = context.read<ProductService>().products;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsDiscoverScreen(
          categoryName: 'All',
          itemCount: products.length,
          onRequireAuth: onRequireAuth,
        ),
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  final Future<bool> Function() onRequireAuth;

  const _CategoriesSection({required this.onRequireAuth});

  void _navigateToResults(BuildContext context, String categoryName) {
    final products = context.read<ProductService>().getProductsByCategory(categoryName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsDiscoverScreen(
          categoryName: categoryName,
          itemCount: products.length,
          onRequireAuth: onRequireAuth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final footwearCount = productService.getProductsByCategory('Footwear').length;
    final apparelCount = productService.getProductsByCategory('Apparel').length;
    final equipmentCount =
        productService.getProductsByCategory('Equipment').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DANH MỤC',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.border.withAlpha(77)),
              bottom: BorderSide(color: AppColors.border.withAlpha(77)),
            ),
          ),
          child: Column(
            children: [
              _CategoryItem(
                icon: Icons.bolt,
                label: 'GIÀY',
                categoryName: 'Footwear',
                itemCount: footwearCount,
                onTap: () => _navigateToResults(context, 'Footwear'),
              ),
              _CategoryItem(
                icon: Icons.checkroom,
                label: 'TRANG PHỤC',
                categoryName: 'Apparel',
                itemCount: apparelCount,
                onTap: () => _navigateToResults(context, 'Apparel'),
              ),
              _CategoryItem(
                icon: Icons.sports_basketball,
                label: 'PHỤ KIỆN',
                categoryName: 'Equipment',
                itemCount: equipmentCount,
                onTap: () => _navigateToResults(context, 'Equipment'),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String categoryName;
  final int itemCount;
  final VoidCallback onTap;
  final bool isLast;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.categoryName,
    required this.itemCount,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: AppColors.border.withAlpha(77)),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: AppColors.textSecondary),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount sản phẩm',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
