import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: AppColors.neon),
        ),
        title: const Text(
          'KINETIC',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
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
          8,
          AppSizes.pagePadding,
          32,
        ),
        children: [
          // ── Hero heading ──
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w900,
                fontSize: 36,
                height: 0.95,
                letterSpacing: -1,
              ),
              children: [
                TextSpan(text: 'SIGNATURE\n'),
                TextSpan(
                  text: 'DROP ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                TextSpan(
                  text: 'EDITION',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'High-performance gear built for the court. Designed to shatter expectations.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // ── Filter chips ──
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FilterChip(label: 'GENDER'),
              _FilterChip(label: 'SIZE'),
              _FilterChip(label: 'PRICE'),
            ],
          ),
          const SizedBox(height: 24),

          // ── Product 1: Featured (Aero-Volt V2) ──
          _FeaturedProductCard(
            badge: 'NEW RELEASE',
            badgeColor: AppColors.neon,
            name: 'AERO-VOLT V2',
            description: 'Maximum responsiveness. Zero gravity feel.',
            price: '\$240',
            onAddToCart: () {},
          ),
          const SizedBox(height: AppSizes.sectionGap),

          // ── Product 2: Stealth Strike ──
          _ProductCard(
            name: 'STEALTH STRIKE',
            description: 'Court-ready lockdown.',
            price: '\$180',
            actionIcon: Icons.add,
            onAction: () {},
          ),
          const SizedBox(height: AppSizes.sectionGap),

          // ── Product 3: Kinetic Core Hoodie ──
          _ProductCard(
            name: 'KINETIC CORE HOODIE',
            description: '',
            price: '\$95',
            badge: 'APPAREL',
            badgeColor: AppColors.neon,
            actionLabel: 'VIEW',
            onAction: () {},
          ),
          const SizedBox(height: AppSizes.sectionGap),

          // ── Product 4: Hyper-Drive PE ──
          _GradientProductCard(
            name: 'HYPER-DRIVE PE',
            description: 'Player-exclusive colorway. Limited run.',
            price: '\$210',
            onAction: () {},
          ),
          const SizedBox(height: 24),

          // ── Load More ──
          GlowButton(
            label: 'LOAD MORE KINETICS',
            icon: Icons.keyboard_arrow_down_rounded,
            isPrimary: false,
            expanded: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ── Filter Chip ──
class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ── Featured Product Card ──
class _FeaturedProductCard extends StatelessWidget {
  final String badge;
  final Color badgeColor;
  final String name;
  final String description;
  final String price;
  final VoidCallback onAddToCart;

  const _FeaturedProductCard({
    required this.badge,
    required this.badgeColor,
    required this.name,
    required this.description,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.cardRadius),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.sports_basketball_rounded,
                color: AppColors.textMuted,
                size: 64,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: badgeColor),
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppColors.neon,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    GlowButton(label: 'ADD TO CART', onPressed: onAddToCart),
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

// ── Regular Product Card ──
class _ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String? badge;
  final Color? badgeColor;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback onAction;

  const _ProductCard({
    required this.name,
    required this.description,
    required this.price,
    this.badge,
    this.badgeColor,
    this.actionLabel,
    this.actionIcon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.cardRadius),
              ),
            ),
            child: badge != null
                ? Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textMuted,
                          size: 40,
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(
                              AppSizes.buttonRadius,
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textMuted,
                      size: 40,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 16),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                // Action: icon button or text button
                actionLabel != null
                    ? GlowButton(
                        label: actionLabel!,
                        isPrimary: false,
                        onPressed: onAction,
                      )
                    : IconButton(
                        onPressed: onAction,
                        icon: Icon(
                          actionIcon ?? Icons.add,
                          color: AppColors.textPrimary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface3,
                          shape: const CircleBorder(),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient Product Card (Hyper-Drive PE) ──
class _GradientProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final VoidCallback onAction;

  const _GradientProductCard({
    required this.name,
    required this.description,
    required this.price,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A2800), Color(0xFF0A0A0A)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 22,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                GlowButton(
                  label: 'QUICK ADD',
                  isPrimary: false,
                  onPressed: onAction,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
