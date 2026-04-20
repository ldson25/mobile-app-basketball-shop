import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../products/presentation/add_product_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 24),
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildRevenueChart(),
              const SizedBox(height: 24),
              _buildRecentOrders(),
              const SizedBox(height: 20),
              _buildQuickStatusCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Text(
          'KINETIC ADMIN',
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.volt,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none_rounded, color: Colors.white),
            Positioned(
              top: -1,
              right: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        const Icon(Icons.settings_outlined, color: AppColors.volt),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERFORMANCE HUB',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 0.95,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Real-time basketball equipment sales and logistics overview. System operational.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'VIEW REPORTS',
                primary: false,
                icon: Icons.analytics_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reports screen chưa làm')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'ADD NEW PRODUCT',
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProductScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return const Column(
      children: [
        _StatCard(
          title: 'DAILY SALES',
          value: '\$12,482.00',
          subtitle: '+14.2% from yesterday',
          icon: Icons.shopping_basket_outlined,
        ),
        SizedBox(height: 16),
        _StatCard(
          title: 'TOTAL ORDERS',
          value: '1,842',
          subtitle: '+22 today',
          icon: Icons.local_shipping_outlined,
        ),
        SizedBox(height: 16),
        _AvgTicketCard(),
      ],
    );
  }

  Widget _buildRevenueChart() {
    final bars = [0.40, 0.65, 0.55, 0.85, 0.75, 0.95, 0.80];
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL'];

    return AppCard(
      color: AppColors.surface2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'REVENUE STREAM',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _legendDot(AppColors.volt, 'Shoes', active: true),
              const SizedBox(width: 14),
              _legendDot(AppColors.outline, 'Apparel'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 230,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 180 * bars[index],
                              decoration: const BoxDecoration(
                                color: AppColors.volt,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          months[index],
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white60,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    final orders = [
      _OrderItemData('Marcus Jordan', '#ORD-9921', 'SHIPPED', AppColors.volt),
      _OrderItemData(
        'Elena Rodriguez',
        '#ORD-9920',
        'PENDING',
        AppColors.warning,
      ),
      _OrderItemData('Tyson Miller', '#ORD-9918', 'SHIPPED', AppColors.volt),
      _OrderItemData('Sarah Chen', '#ORD-9915', 'REFUNDED', AppColors.danger),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RECENT ORDERS',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                'View All',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.volt,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...orders.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _OrderTile(data: e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatusCards() {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.volt, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'LOW STOCK ALERT',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Impact V2 Shoes',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Only 3 units remaining',
                style: GoogleFonts.inter(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: AppColors.volt,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TOP SELLER',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Gravity Hoops Jersey',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '428 units this week',
                style: GoogleFonts.inter(
                  color: AppColors.volt,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.volt, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'CAMPAIGN PERFORMANCE',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Summer Slam Collection',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Click-through rate increased by 24% in last 48 hours.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String text, {bool active = false}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            color: active ? Colors.white : Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.volt,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.volt,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 78, color: Colors.white.withOpacity(0.08)),
        ],
      ),
    );
  }
}

class _AvgTicketCard extends StatelessWidget {
  const _AvgTicketCard();

  @override
  Widget build(BuildContext context) {
    final bars = [18.0, 34.0, 28.0, 46.0, 22.0];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVG. TICKET',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$142.50',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 0.95,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: bars
                    .map(
                      (e) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 6,
                        height: e,
                        decoration: BoxDecoration(
                          color: AppColors.volt,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Market trends indicate shift to signature footwear.',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemData {
  final String name;
  final String code;
  final String status;
  final Color statusColor;

  _OrderItemData(this.name, this.code, this.status, this.statusColor);
}

class _OrderTile extends StatelessWidget {
  final _OrderItemData data;

  const _OrderTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.volt.withOpacity(0.12),
            ),
            child: const Icon(Icons.person, color: AppColors.volt, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.code,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: data.statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              data.status,
              style: GoogleFonts.spaceGrotesk(
                color: data.statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
