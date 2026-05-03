import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

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
        title: const SizedBox.shrink(),
      ),
      bottomNavigationBar: KineticBottomNav(currentIndex: 2, onTap: (index) {}),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          8,
          AppSizes.pagePadding,
          32,
        ),
        children: const [
          _HeroSection(),
          SizedBox(height: 20),
          _EstimatedArrivalCard(),
          SizedBox(height: 24),
          _TrackingSteps(),
          SizedBox(height: 20),
          _MapPlaceholder(),
          SizedBox(height: 20),
          _DeliveryAddressCard(),
          SizedBox(height: 16),
          _CarrierDetailsCard(),
          SizedBox(height: 16),
          _ContactSupportButton(),
          SizedBox(height: 28),
          _GearSection(),
        ],
      ),
    );
  }
}

// ── Hero: order id + status ──
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDER #KNC-882910',
          style: TextStyle(
            color: AppColors.neon,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'IN TRANSIT',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 42),
        ),
      ],
    );
  }
}

// ── Estimated Arrival Card ──
class _EstimatedArrivalCard extends StatelessWidget {
  const _EstimatedArrivalCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      border: const Border(left: BorderSide(color: AppColors.neon, width: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ESTIMATED ARRIVAL',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Today, 4:30 PM',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 32),
          ),
        ],
      ),
    );
  }
}

// ── Tracking Steps ──
class _TrackingSteps extends StatelessWidget {
  const _TrackingSteps();

  static const _steps = [
    _Step(label: 'PROCESSING', icon: Icons.inventory_2_rounded, done: true),
    _Step(label: 'SHIPPED', icon: Icons.local_shipping_rounded, done: true),
    _Step(label: 'IN TRANSIT', icon: Icons.near_me_rounded, active: true),
    _Step(label: 'DELIVERED', icon: Icons.check_circle_rounded, done: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _steps.map((s) => _StepItem(step: s)).toList(),
    );
  }
}

class _Step {
  final String label;
  final IconData icon;
  final bool done;
  final bool active;
  const _Step({
    required this.label,
    required this.icon,
    this.done = false,
    this.active = false,
  });
}

class _StepItem extends StatelessWidget {
  final _Step step;
  const _StepItem({required this.step});

  @override
  Widget build(BuildContext context) {
    final color = step.active
        ? AppColors.neon
        : step.done
        ? AppColors.neon.withOpacity(0.5)
        : AppColors.surface3;
    final iconColor = step.active ? Colors.black : AppColors.textSecondary;

    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: step.active
                ? [
                    BoxShadow(
                      color: AppColors.neon.withOpacity(0.4),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Icon(step.icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          step.label,
          style: TextStyle(
            color: step.active ? AppColors.neon : AppColors.textSecondary,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ── Map Placeholder ──
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            child: const Center(
              child: Icon(
                Icons.map_outlined,
                color: AppColors.textMuted,
                size: 48,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENT LOCATION',
                  style: TextStyle(
                    color: AppColors.neon,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Downtown Logistics Hub, Sector 4',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.neon,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Delivery Address ──
class _DeliveryAddressCard extends StatelessWidget {
  const _DeliveryAddressCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: AppColors.neon, size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DELIVERY ADDRESS',
                style: TextStyle(
                  color: AppColors.neon,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Alex Rivera',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 16),
              ),
              const Text(
                '482 Kinetic Blvd, Suite 101\nObsidian City, OC 90210',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Carrier Details ──
class _CarrierDetailsCard extends StatelessWidget {
  const _CarrierDetailsCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.neon,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.black,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CARRIER DETAILS',
                style: TextStyle(
                  color: AppColors.neon,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Volt Express',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 16),
              ),
              const Text(
                'Tracking: VX-7721-KK',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Contact Support Button ──
class _ContactSupportButton extends StatelessWidget {
  const _ContactSupportButton();

  @override
  Widget build(BuildContext context) {
    return GlowButton(
      label: 'CONTACT SUPPORT',
      icon: Icons.headset_mic_rounded,
      isPrimary: false,
      expanded: true,
      onPressed: () {},
    );
  }
}

// ── Your Gear Section ──
class _GearSection extends StatelessWidget {
  const _GearSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR GEAR',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 16),
        const _GearItem(
          name: 'KINETIC V1 "VOLT"',
          detail: 'Size: 10.5 | Color: Hyper Neon',
          price: '\$189.00',
          icon: Icons.sports_basketball_rounded,
        ),
        const SizedBox(height: 12),
        const _GearItem(
          name: 'ELITE PERFORMANCE HOODIE',
          detail: 'Size: L | Color: Midnight Matte',
          price: '\$95.00',
          icon: Icons.checkroom_rounded,
        ),
        const SizedBox(height: 20),
        const Divider(color: AppColors.border, thickness: 0.4),
        const SizedBox(height: 12),
        _SummaryRow(label: 'Subtotal', value: '\$284.00'),
        _SummaryRow(
          label: 'Shipping (Express)',
          value: 'FREE',
          valueColor: AppColors.neon,
        ),
        _SummaryRow(label: 'Tax', value: '\$22.72'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TOTAL CHARGED',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '\$306.72',
              style: TextStyle(
                color: AppColors.neon,
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GearItem extends StatelessWidget {
  final String name;
  final String detail;
  final String price;
  final IconData icon;

  const _GearItem({
    required this.name,
    required this.detail,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: AppColors.neon,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
