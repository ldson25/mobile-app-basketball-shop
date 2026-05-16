// lib/features/discover/presentation/discover_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../models/product_model.dart';
import '../cart/mycart.dart';
import '../menudrawer/menudrawer.dart';
import '../../widgets/kinetic_bottom_nav.dart';
import 'results_discover_screen.dart';
import '../../widgets/product_card.dart';

class DiscoverScreen extends StatelessWidget {
  final VoidCallback onMenuTap; 

  const DiscoverScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _CustomAppBar(onMenuTap: onMenuTap), 
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 20),
              _SearchSection(),
              SizedBox(height: 48),
              _CategoriesSection(),
              SizedBox(height: 32),
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
          bottom: BorderSide(
            color: AppColors.border.withAlpha(77),
          ),
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
                  icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                ),
              ),
            ),
            const Center(
              child: Text(
                'DISCOVER',
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
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
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
  const _SearchSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface2.withAlpha(128),
        border: Border.all(
          color: AppColors.border.withAlpha(77),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'FIND YOUR SPEED',
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              onSubmitted: (value) {
                // Điều hướng đến results với từ khóa tìm kiếm
                if (value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsDiscoverScreen(
                        categoryName: 'SEARCH RESULTS',
                        itemCount: 42,
                        searchKeyword: value,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              // Mở filter dialog
              _showSearchFilter(context);
            },
            child: const Icon(
              Icons.tune,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void _showSearchFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'FILTER SEARCH',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              // Thêm các filter options ở đây
              const Text('Filter options will be added here'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: AppColors.background,
                ),
                child: const Text('APPLY'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATEGORIES',
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
                label: 'FOOTWEAR',
                categoryName: 'Footwear',
                onTap: () {
                  _navigateToResults(context, 'Footwear');
                },
              ),
              _CategoryItem(
                icon: Icons.checkroom,
                label: 'APPAREL',
                categoryName: 'Apparel',
                onTap: () {
                  _navigateToResults(context, 'Apparel');
                },
              ),
              _CategoryItem(
                icon: Icons.sports_basketball,
                label: 'EQUIPMENT',
                categoryName: 'Equipment',
                onTap: () {
                  _navigateToResults(context, 'Equipment');
                },
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToResults(BuildContext context, String categoryName) {
    final products = ProductData.getProductsByCategory(categoryName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsDiscoverScreen(
          categoryName: categoryName,
          itemCount: products.length, 
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String categoryName;
  final VoidCallback onTap;
  final bool isLast;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.categoryName,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy số lượng sản phẩm chính xác từ ProductData
    final products = ProductData.getProductsByCategory(categoryName);
    final itemCount = products.length;
    
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
                Icon(
                  icon,
                  size: 28,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount items',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}