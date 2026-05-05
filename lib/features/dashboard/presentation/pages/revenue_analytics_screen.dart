import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class RevenueAnalyticsScreen extends StatefulWidget {
  const RevenueAnalyticsScreen({super.key});

  @override
  State<RevenueAnalyticsScreen> createState() => _RevenueAnalyticsScreenState();
}

class _RevenueAnalyticsScreenState extends State<RevenueAnalyticsScreen> {
  int _selectedTrendTab = 0; // 0=Day, 1=Month, 2=Year
  final _trendTabs = ['DAY', 'MONTH', 'YEAR'];

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
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      bottomNavigationBar: KineticBottomNav(
        currentIndex: 3, // Profile tab (Admin)
        onTap: (index) {},
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          8,
          AppSizes.pagePadding,
          32,
        ),
        children: [
          // ── Header ──
          const Text(
            'ANALYTICS CONSOLE',
            style: TextStyle(
              color: AppColors.neon,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'REVENUE\nOVERVIEW',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 16),

          // ── Date picker pill ──
          SectionCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text(
                  'Oct 1, 2023 - Oct 31, 2023',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.neon,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── KPI Cards ──
          _KpiCard(
            label: 'TOTAL REVENUE',
            value: '\$142,590',
            trend: '+14.5%',
            trendUp: true,
            icon: Icons.account_balance_wallet_rounded,
          ),
          const SizedBox(height: 14),
          _KpiCard(
            label: 'AVERAGE ORDER VALUE',
            value: '\$345.50',
            trend: '+5.2%',
            trendUp: true,
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 14),
          _KpiCard(
            label: 'CONVERSION RATE',
            value: '4.8%',
            trend: '-1.2%',
            trendUp: false,
            icon: Icons.show_chart_rounded,
          ),
          const SizedBox(height: 24),

          // ── Revenue Trend Chart ──
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'REVENUE TREND',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 18),
                    ),
                    // Tab switcher
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(
                          AppSizes.buttonRadius,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: List.generate(_trendTabs.length, (i) {
                          final active = _selectedTrendTab == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTrendTab = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.surface3
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.buttonRadius,
                                ),
                              ),
                              child: Text(
                                _trendTabs[i],
                                style: TextStyle(
                                  color: active
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Mock line chart
                const _LineChartMock(),
                const SizedBox(height: 8),
                // X-axis labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _AxisLabel('Oct 1'),
                    _AxisLabel('Oct 5'),
                    _AxisLabel('Oct 10'),
                    _AxisLabel('Oct 15'),
                    _AxisLabel('Oct 20'),
                    _AxisLabel('Oct 25'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Sales by Category Bar Chart ──
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SALES BY CATEGORY',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const _BarChartMock(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _AxisLabel('SIG'),
                    _AxisLabel('PERF'),
                    _AxisLabel('LIFE'),
                    _AxisLabel('ACC'),
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

// ── KPI Card ──
class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final bool trendUp;
  final IconData icon;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.trendUp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = trendUp ? AppColors.neon : AppColors.error;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.neon, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 38),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                trendUp ? Icons.trending_up : Icons.trending_down,
                color: trendColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'vs last month',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Mock Line Chart ──
class _LineChartMock extends StatelessWidget {
  const _LineChartMock();

  @override
  Widget build(BuildContext context) {
    // Y-axis labels + chart area
    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Y-axis
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _AxisLabel('\$50k'),
              _AxisLabel('\$37.5k'),
              _AxisLabel('\$25k'),
              _AxisLabel('\$12.5k'),
              _AxisLabel('0'),
            ],
          ),
          const SizedBox(width: 8),
          // Chart
          Expanded(child: CustomPaint(painter: _LineChartPainter())),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Data points (normalized 0..1)
    final points = [
      Offset(0.0, 0.8),
      Offset(0.2, 0.6),
      Offset(0.4, 0.75),
      Offset(0.6, 0.4),
      Offset(0.8, 0.5),
      Offset(1.0, 0.2),
    ];

    final mapped = points
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();

    // Fill area
    final fillPath = Path()..moveTo(mapped.first.dx, mapped.first.dy);
    for (final p in mapped.skip(1)) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.neon.withOpacity(0.3),
            AppColors.neon.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path()..moveTo(mapped.first.dx, mapped.first.dy);
    for (final p in mapped.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.neon
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Dots
    for (final p in mapped) {
      canvas.drawCircle(p, 4, Paint()..color = AppColors.neon);
    }

    // Tooltip on last point
    final last = mapped.last;
    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(last.dx - 30, last.dy - 28),
        width: 70,
        height: 34,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(tooltipRect, Paint()..color = AppColors.surface3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Mock Bar Chart ──
class _BarChartMock extends StatelessWidget {
  const _BarChartMock();

  @override
  Widget build(BuildContext context) {
    final bars = [
      _Bar(label: 'SIG', heightFactor: 0.85, active: false),
      _Bar(label: 'PERF', heightFactor: 0.45, active: false),
      _Bar(label: 'LIFE', heightFactor: 0.6, active: true, value: '\$60k'),
      _Bar(label: 'ACC', heightFactor: 0.2, active: false),
    ];

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Y-axis
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_AxisLabel('100%'), _AxisLabel('50%'), _AxisLabel('0')],
          ),
          const SizedBox(width: 8),
          // Bars
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: bars.map((bar) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (bar.value != null)
                          Text(
                            bar.value!,
                            style: const TextStyle(
                              color: AppColors.neon,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        const SizedBox(height: 4),
                        FractionallySizedBox(
                          heightFactor: bar.heightFactor,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bar.active
                                  ? AppColors.neon
                                  : AppColors.surface3,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                              boxShadow: bar.active
                                  ? [
                                      BoxShadow(
                                        color: AppColors.neon.withOpacity(0.2),
                                        blurRadius: 12,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar {
  final String label;
  final double heightFactor;
  final bool active;
  final String? value;
  const _Bar({
    required this.label,
    required this.heightFactor,
    required this.active,
    this.value,
  });
}

class _AxisLabel extends StatelessWidget {
  final String text;
  const _AxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 9,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
