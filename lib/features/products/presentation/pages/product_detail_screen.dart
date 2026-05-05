import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSize = 10;
  final _sizes = [8, 9, 10, 11, 12, 13];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      bottomNavigationBar: KineticBottomNav(currentIndex: 1, onTap: (index) {}),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          0,
          AppSizes.pagePadding,
          32,
        ),
        children: [
          // ── Breadcrumb ──
          const Text(
            'PERFORMANCE  /  FOOTWEAR  /  BOLT V1',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          // ── Badge ──
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.neon,
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              ),
              child: const Text(
                'ELITE PERFORMANCE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Product Image ──
          Container(
            height: 260,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            child: const Center(
              child: Icon(
                Icons.sports_basketball_rounded,
                color: AppColors.textMuted,
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Thumbnail row ──
          Row(
            children: [
              _Thumbnail(active: true),
              const SizedBox(width: 10),
              _Thumbnail(),
              const Spacer(),
              // Feature badge
              Container(
                width: 90,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt_rounded, color: AppColors.neon, size: 18),
                    SizedBox(height: 4),
                    Text(
                      'KINETIC\nENERGY\nRETURN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Product name + price ──
          Text(
            'KINETIC BOLT V1',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 36, height: 0.95),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$225.00',
            style: TextStyle(
              color: AppColors.neon,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),

          // ── Size selector ──
          const Text(
            'SELECT SIZE (US)',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _sizes
                .map(
                  (size) => _SizeChip(
                    size: size,
                    selected: _selectedSize == size,
                    onTap: () => setState(() => _selectedSize = size),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          // ── Specs row ──
          SectionCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _SpecItem(label: 'WEIGHT', value: '340G'),
                _SpecItem(label: 'CUSHION', value: 'NITRO-F'),
                _SpecItem(label: 'MATERIAL', value: 'ARMOR-M'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Add to Cart ──
          GlowButton(
            label: 'ADD TO CART',
            icon: Icons.shopping_bag_outlined,
            expanded: true,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          GlowButton(
            label: 'ADD TO WISHLIST',
            icon: Icons.favorite_border_rounded,
            isPrimary: false,
            expanded: true,
            onPressed: () {},
          ),
          const SizedBox(height: 20),

          // ── Expandable sections ──
          const _ExpandableRow(label: 'DESCRIPTION'),
          const Divider(color: AppColors.border, thickness: 0.4),
          const _ExpandableRow(label: 'SHIPPING & RETURNS'),
          const SizedBox(height: 28),

          // ── Editorial block ──
          const _EditorialBlock(),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final bool active;
  const _Thumbnail({this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: BorderRadius.circular(12),
        border: active ? Border.all(color: AppColors.neon, width: 2) : null,
      ),
      child: const Icon(
        Icons.sports_basketball_rounded,
        color: AppColors.textMuted,
        size: 28,
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final int size;
  final bool selected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.size,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.neon : AppColors.surface3,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          border: selected ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          '$size',
          style: TextStyle(
            color: selected ? Colors.black : AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;

  const _SpecItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ExpandableRow extends StatelessWidget {
  final String label;
  const _ExpandableRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _EditorialBlock extends StatelessWidget {
  const _EditorialBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENGINEERED MOTION',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 16),
        SectionCard(
          color: AppColors.surface2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sports_basketball_rounded,
                    color: AppColors.textMuted,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'GRAVITY\nDEFIED',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Built with the lightest synthetic fibers known to the sport.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.neon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.black,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ELITE SIGNATURE',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'The choice of world-class athletes seeking the ultimate competitive edge.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
