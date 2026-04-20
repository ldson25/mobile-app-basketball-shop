import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/recent_order_tile.dart';
import '../widgets/simple_revenue_chart.dart';

class PerformanceHubPage extends StatelessWidget {
  const PerformanceHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 20),
              Text(
                'PERFORMANCE HUB',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 30, height: 0.95),
              ),
              const SizedBox(height: 10),
              const Text(
                'Real-time basketball equipment sales and logistics overview. System operational.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: GlowButton(
                      label: 'View Reports',
                      icon: Icons.analytics_outlined,
                      isPrimary: false,
                      expanded: true,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: GlowButton(
                      label: 'Add New Product',
                      icon: Icons.add,
                      expanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sectionGap),
              const DashboardMetricCard(
                label: 'Daily Sales',
                value: '\$12,482.00',
                change: '+14.2% from yesterday',
                icon: Icons.shopping_basket_rounded,
                compact: true,
              ),
              const SizedBox(height: 16),
              const DashboardMetricCard(
                label: 'Total Orders',
                value: '1,842',
                change: '+22 today',
                icon: Icons.local_shipping_rounded,
                compact: true,
              ),
              const SizedBox(height: 16),
              const SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AVG. TICKET',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$142.50',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _MiniBar(height: 16),
                            _MiniBar(height: 28),
                            _MiniBar(height: 22),
                            _MiniBar(height: 40),
                            _MiniBar(height: 18),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Market trends indicate shift to signature footwear.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              const SectionCard(
                color: Color(0xFF151515),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'REVENUE\nSTREAM',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              height: 0.95,
                            ),
                          ),
                        ),
                        _LegendDot(label: 'Shoes', color: AppColors.neon),
                        SizedBox(width: 12),
                        _LegendDot(
                          label: 'Apparel',
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    SimpleRevenueChart(),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              const SectionCard(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'RECENT ORDERS',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.neon,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: AppColors.border),
                    RecentOrderTile(
                      customer: 'Marcus Jordan',
                      orderId: '#ORD-9921',
                      status: 'Shipped',
                      statusColor: AppColors.neon,
                    ),
                    Divider(color: AppColors.border),
                    RecentOrderTile(
                      customer: 'Elena Rodriguez',
                      orderId: '#ORD-9920',
                      status: 'Pending',
                      statusColor: AppColors.warning,
                    ),
                    Divider(color: AppColors.border),
                    RecentOrderTile(
                      customer: 'Tyson Miller',
                      orderId: '#ORD-9918',
                      status: 'Shipped',
                      statusColor: AppColors.neon,
                    ),
                    Divider(color: AppColors.border),
                    RecentOrderTile(
                      customer: 'Sarah Chen',
                      orderId: '#ORD-9915',
                      status: 'Refunded',
                      statusColor: AppColors.error,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              const _StatusCard(
                icon: Icons.bolt_rounded,
                label: 'LOW STOCK ALERT',
                title: 'Impact V2 Shoes',
                value: 'Only 3 units remaining',
                valueColor: AppColors.error,
              ),
              const SizedBox(height: 16),
              const _StatusCard(
                icon: Icons.trending_up_rounded,
                label: 'TOP SELLER',
                title: 'Gravity Hoops Jersey',
                value: '428 units this week',
                valueColor: AppColors.neon,
              ),
              const SizedBox(height: 16),
              const _CampaignCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: AppColors.neon),
        ),
        const Text(
          'KINETIC ADMIN',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        const Spacer(),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            const Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                radius: 3.5,
                backgroundColor: AppColors.error,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_rounded, color: AppColors.neon),
        ),
      ],
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.neon,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.label,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.neon, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF101010)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.sports_basketball_rounded,
              size: 110,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.neon, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'CAMPAIGN PERFORMANCE',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Summer Slam Collection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 6),
              Text(
                'Click-through rate increased by 24% in last 48 hours.',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
