import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
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
          _OrderShippedCard(),
          SizedBox(height: AppSizes.sectionGap),
          _NewDropAlertCard(),
          SizedBox(height: AppSizes.sectionGap),
          _PriceDropCard(),
          SizedBox(height: AppSizes.sectionGap),
          _SupportMessageCard(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card 1: Order Shipped
// ─────────────────────────────────────────────
class _OrderShippedCard extends StatelessWidget {
  const _OrderShippedCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.neon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.black,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _TagLabel('ORDER UPDATE', color: AppColors.neon),
                        _TimeLabel('2 hours ago'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const _CardTitle('Order Shipped'),
                    const SizedBox(height: 6),
                    const _CardBody(
                      'Your order #KNTC-8892 is on its way. Track your package to see when it lands.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const GlowButton(
            label: 'TRACK ORDER',
            icon: Icons.location_on_rounded,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card 2: New Drop Alert
// ─────────────────────────────────────────────
class _NewDropAlertCard extends StatelessWidget {
  const _NewDropAlertCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.neon,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _TagLabel(
                      'RELEASE RADAR',
                      color: AppColors.textSecondary,
                    ),
                    _TimeLabel('Yesterday'),
                  ],
                ),
                const SizedBox(height: 6),
                const _CardTitle('New Drop Alert'),
                const SizedBox(height: 6),
                const _CardBody(
                  "The 'Velocity' signature series just hit the gallery. Extremely limited run. Secure yours now.",
                ),
                const SizedBox(height: 14),
                const GlowButton(
                  label: 'VIEW COLLECTION',
                  icon: Icons.arrow_forward_rounded,
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card 3: Price Drop on Favorites
// ─────────────────────────────────────────────
class _PriceDropCard extends StatelessWidget {
  const _PriceDropCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      border: const Border(left: BorderSide(color: AppColors.neon, width: 4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.surface3,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sell_rounded,
              color: AppColors.textPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _TagLabel('SAVED ITEM', color: AppColors.neon),
                    _TimeLabel('Oct 24'),
                  ],
                ),
                const SizedBox(height: 6),
                const _CardTitle('Price Drop on Favorites'),
                const SizedBox(height: 6),
                const _CardBody(
                  'Good eye. The item you saved just dropped in price. Grab it before someone else does.',
                ),
                const SizedBox(height: 14),
                const GlowButton(
                  label: 'SHOP NOW',
                  icon: Icons.shopping_bag_outlined,
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card 4: Support Message (dimmed / đã đọc)
// ─────────────────────────────────────────────
class _SupportMessageCard extends StatelessWidget {
  const _SupportMessageCard();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: SectionCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.surface3,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.forum_rounded,
                color: AppColors.textPrimary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _TagLabel(
                        'CUSTOMER SERVICE',
                        color: AppColors.textSecondary,
                      ),
                      _TimeLabel('Oct 22'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const _CardTitle('Support Message', size: 20),
                  const SizedBox(height: 6),
                  const _CardBody(
                    "We've resolved the issue with your recent return request. View the details here.",
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.neon,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: const Text('READ MESSAGE'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Micro-widgets nội bộ của màn hình này
// ─────────────────────────────────────────────

class _TagLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _TagLabel(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  final String text;

  const _TimeLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String text;
  final double size;

  const _CardTitle(this.text, {this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: size),
    );
  }
}

class _CardBody extends StatelessWidget {
  final String text;

  const _CardBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
