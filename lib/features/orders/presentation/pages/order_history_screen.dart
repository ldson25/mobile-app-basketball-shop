import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.neon),
        ),
        title: const Text(
          'ORDER HISTORY',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: AppColors.neon),
          ),
        ],
      ),
      bottomNavigationBar: KineticBottomNav(
        currentIndex: 2, // Orders tab
        onTap: (index) {},
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          16,
          AppSizes.pagePadding,
          32,
        ),
        children: const [
          // ── Hero Section ──
          _HeroSection(),
          SizedBox(height: 24),

          // ── Order Cards ──
          _OrderCard(
            orderId: '#KT-9921',
            date: 'Placed on Oct 24, 2023',
            status: 'Delivered',
            statusColor: AppColors.neon,
            borderColor: AppColors.neon,
            totalAmount: '\$345.00',
            productCount: 3,
          ),
          SizedBox(height: AppSizes.sectionGap),
          _OrderCard(
            orderId: '#KT-9844',
            date: 'Placed on Nov 12, 2023',
            status: 'In Transit',
            statusColor: AppColors.textPrimary,
            borderColor: Colors.white24,
            totalAmount: '\$180.00',
            productCount: 1,
            statusIcon: Icons.local_shipping_rounded,
          ),
          SizedBox(height: AppSizes.sectionGap),
          _OrderCard(
            orderId: '#KT-9902',
            date: 'Placed on Nov 15, 2023',
            status: 'Processing',
            statusColor: AppColors.textSecondary,
            borderColor: AppColors.outline,
            totalAmount: '\$65.00',
            productCount: 1,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero Section — "PAST DEPLOYMENTS"
// ─────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ARCHIVE',
          style: TextStyle(
            color: AppColors.neon,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'PAST\nDEPLOYMENTS',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 38,
            fontStyle: FontStyle.italic,
            height: 0.95,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Order Card
// ─────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final Color statusColor;
  final Color borderColor;
  final String totalAmount;
  final int productCount;
  final IconData? statusIcon;

  const _OrderCard({
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.borderColor,
    required this.totalAmount,
    required this.productCount,
    this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(20),
      border: Border(left: BorderSide(color: borderColor, width: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: order ref + status badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORDER REFERENCE',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    orderId,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              _StatusBadge(label: status, color: statusColor, icon: statusIcon),
            ],
          ),
          const SizedBox(height: 20),

          // ── Product thumbnails ──
          _ProductThumbnailRow(count: productCount),
          const SizedBox(height: 16),

          // ── Divider ──
          const Divider(color: AppColors.border, thickness: 0.4),
          const SizedBox(height: 12),

          // ── Footer: total + reorder button ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL AMOUNT',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalAmount,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 22),
                  ),
                ],
              ),
              GlowButton(
                label: 'REORDER',
                icon: Icons.refresh_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Status Badge
// ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _StatusBadge({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Product Thumbnail Row (horizontal scroll)
// ─────────────────────────────────────────────
class _ProductThumbnailRow extends StatelessWidget {
  final int count;

  const _ProductThumbnailRow({required this.count});

  @override
  Widget build(BuildContext context) {
    // Hiển thị tối đa 2 thumbnail + 1 overflow nếu count > 2
    final visibleCount = count > 2 ? 2 : count;
    final overflow = count > 2 ? count - 2 : 0;

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: visibleCount + (overflow > 0 ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          // Thumbnail overflow (+N)
          if (overflow > 0 && index == visibleCount) {
            return _OverflowThumbnail(count: overflow);
          }
          return _Thumbnail();
        },
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius / 2),
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textMuted,
        size: 28,
      ),
    );
  }
}

class _OverflowThumbnail extends StatelessWidget {
  final int count;

  const _OverflowThumbnail({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius / 2),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
