import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminPageScaffold(
      title: 'ADMIN\nDASHBOARD',
      subtitle: 'Realtime operations overview',
      children: [
        GlowButton(
          label: 'VIEW REPORT',
          icon: Icons.analytics_outlined,
          expanded: true,
          onPressed: () => _showReportSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminMetricCard(
          label: 'Today revenue',
          value: '\$12.840',
          icon: Icons.bolt_rounded,
          delta: '+18% from yesterday',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Pending orders',
          value: '42',
          icon: Icons.receipt_long_rounded,
          delta: '8 orders need confirmation',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Low stock products',
          value: '11',
          icon: Icons.inventory_2_outlined,
          delta: 'Restock queue ready',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'New customers',
          value: '36',
          icon: Icons.groups_rounded,
          delta: 'This week',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Operations', title: 'Action queue'),
        const SizedBox(height: 14),
        const _ActionQueueCard(
          title: 'Confirm pending orders',
          detail: '8 paid orders are waiting for confirmation',
          icon: Icons.task_alt_rounded,
          color: AppColors.warning,
        ),
        const SizedBox(height: 12),
        const _ActionQueueCard(
          title: 'Restock low inventory',
          detail: 'Velocity X, Apex Core and 9 more products',
          icon: Icons.inventory_rounded,
          color: AppColors.error,
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Audit', title: 'Recent activity'),
        const SizedBox(height: 14),
        const _ActivityLogTile(
          actor: 'admin@kinetic.app',
          action: 'updated order #ORD-8821 to confirmed',
          time: '2 min ago',
        ),
        const SizedBox(height: 10),
        const _ActivityLogTile(
          actor: 'ops@kinetic.app',
          action: 'adjusted Hypervolt v1 stock',
          time: '18 min ago',
        ),
        const SizedBox(height: 10),
        const _ActivityLogTile(
          actor: 'admin@kinetic.app',
          action: 'created featured banner',
          time: '1 hour ago',
        ),
      ],
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminSectionTitle(eyebrow: 'Report', title: 'Export options'),
              SizedBox(height: 16),
              _ReportOption(icon: Icons.today_rounded, label: 'Daily summary'),
              SizedBox(height: 10),
              _ReportOption(icon: Icons.date_range_rounded, label: 'Monthly revenue'),
              SizedBox(height: 10),
              _ReportOption(icon: Icons.inventory_2_rounded, label: 'Inventory status'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionQueueCard extends StatelessWidget {
  const _ActionQueueCard({
    required this.title,
    required this.detail,
    required this.icon,
    required this.color,
  });

  final String title;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _ActivityLogTile extends StatelessWidget {
  const _ActivityLogTile({
    required this.actor,
    required this.action,
    required this.time,
  });

  final String actor;
  final String action;
  final String time;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.neon,
            foregroundColor: AppColors.background,
            child: Icon(Icons.admin_panel_settings_rounded, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actor,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(action, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ReportOption extends StatelessWidget {
  const _ReportOption({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Icon(Icons.download_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
