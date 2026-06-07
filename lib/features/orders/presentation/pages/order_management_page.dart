import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../widgets/order_item_card.dart';

class OrderManagementPage extends StatelessWidget {
  const OrderManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.neon,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 22),
              Text(
                'ORDER\nMANAGEMENT',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 34),
              ),
              const SizedBox(height: 12),
              Text(
                'ELITE OPERATIONAL OVERVIEW — Q4 PHASE',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              const GlowButton(
                label: 'EXPORT CSV',
                icon: Icons.download_rounded,
              ),
              const SizedBox(height: 24),
              const _FilterField(
                label: 'Search Reference',
                hint: 'Order ID or Customer...',
              ),
              const SizedBox(height: 14),
              const _DropdownField(
                label: 'Status Filter',
                value: 'ALL STATUSES',
              ),
              const SizedBox(height: 14),
              const _FilterField(
                label: 'Date Range',
                hint: 'mm/dd/yyyy',
                suffix: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 14),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'CLEAR ALL FILTERS',
                      style: TextStyle(
                        color: AppColors.neon,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              OrderItemCard(
                orderId: '#ORD-8821',
                customer: 'Marcus V.',
                itemCount: '2 Items',
                amount: '\$340.00',
                date: 'OCT 24, 2023 • 14:22',
                status: 'Pending',
                statusColor: AppColors.warning,
              ),
              const SizedBox(height: 16),
              OrderItemCard(
                orderId: '#ORD-8790',
                customer: 'Elena S.',
                itemCount: '1 Item',
                amount: '\$185.50',
                date: 'OCT 23, 2023 • 09:15',
                status: 'Paid',
                statusColor: AppColors.neon,
              ),
              const SizedBox(height: 16),
              OrderItemCard(
                orderId: '#ORD-8742',
                customer: 'Jordan K.',
                itemCount: '3 Items',
                amount: '\$590.00',
                date: 'OCT 21, 2023 • 18:45',
                status: 'Shipped',
                statusColor: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              OrderItemCard(
                orderId: '#ORD-8711',
                customer: 'Liam W.',
                itemCount: '1 Item',
                amount: '\$120.00',
                date: 'OCT 20, 2023 • 11:00',
                status: 'Cancelled',
                statusColor: AppColors.error,
                dimmed: true,
              ),
              const SizedBox(height: 24),
              const _Pagination(),
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
          icon: Icon(Icons.menu_rounded, color: AppColors.neon),
        ),
        Text(
          'KINETIC',
          style: TextStyle(
            color: AppColors.neon,
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.shopping_bag_outlined, color: AppColors.neon),
        ),
      ],
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({required this.label, required this.hint, this.suffix});

  final String label;
  final String hint;
  final IconData? suffix;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (suffix != null)
                Icon(suffix, color: AppColors.textMuted, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination();

  @override
  Widget build(BuildContext context) {
    Widget item(String text, {bool active = false}) {
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: active ? AppColors.neon : AppColors.surface,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Prev', style: TextStyle(color: AppColors.textMuted)),
        const SizedBox(width: 14),
        item('1', active: true),
        const SizedBox(width: 8),
        item('2'),
        const SizedBox(width: 8),
        item('3'),
        const SizedBox(width: 14),
        Text('Next', style: TextStyle(color: AppColors.textPrimary)),
      ],
    );
  }
}
