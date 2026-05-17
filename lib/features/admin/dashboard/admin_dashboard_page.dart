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
      title: 'TỔNG QUAN\nADMIN',
      subtitle: 'Theo dõi vận hành cửa hàng theo thời gian thực',
      children: [
        GlowButton(
          label: 'XEM BÁO CÁO',
          icon: Icons.analytics_outlined,
          expanded: true,
          onPressed: () => _showReportSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminMetricCard(
          label: 'Doanh thu hôm nay',
          value: '321.000.000đ',
          icon: Icons.bolt_rounded,
          delta: '+18% so với hôm qua',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Đơn chờ xử lý',
          value: '42',
          icon: Icons.receipt_long_rounded,
          delta: '8 đơn cần xác nhận',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Sản phẩm sắp hết hàng',
          value: '11',
          icon: Icons.inventory_2_outlined,
          delta: 'Cần bổ sung tồn kho',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Khách hàng mới',
          value: '36',
          icon: Icons.groups_rounded,
          delta: 'Tuần này',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Vận hành', title: 'Việc cần xử lý'),
        const SizedBox(height: 14),
        const _ActionQueueCard(
          title: 'Xác nhận đơn chờ xử lý',
          detail: '8 đơn hàng đang chờ admin xác nhận',
          icon: Icons.task_alt_rounded,
          color: AppColors.warning,
        ),
        const SizedBox(height: 12),
        const _ActionQueueCard(
          title: 'Nhập thêm hàng tồn thấp',
          detail: 'Velocity X, Apex Core và 9 sản phẩm khác',
          icon: Icons.inventory_rounded,
          color: AppColors.error,
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Nhật ký', title: 'Hoạt động gần đây'),
        const SizedBox(height: 14),
        const _ActivityLogTile(
          actor: 'admin@kinetic.app',
          action: 'đã xác nhận đơn #ORD-8821',
          time: '2 phút trước',
        ),
        const SizedBox(height: 10),
        const _ActivityLogTile(
          actor: 'ops@kinetic.app',
          action: 'đã cập nhật tồn kho Hypervolt v1',
          time: '18 phút trước',
        ),
        const SizedBox(height: 10),
        const _ActivityLogTile(
          actor: 'admin@kinetic.app',
          action: 'đã tạo banner nổi bật',
          time: '1 giờ trước',
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
              AdminSectionTitle(eyebrow: 'Báo cáo', title: 'Tùy chọn xuất'),
              SizedBox(height: 16),
              _ReportOption(icon: Icons.today_rounded, label: 'Tổng kết ngày'),
              SizedBox(height: 10),
              _ReportOption(icon: Icons.date_range_rounded, label: 'Doanh thu tháng'),
              SizedBox(height: 10),
              _ReportOption(icon: Icons.inventory_2_rounded, label: 'Tình trạng tồn kho'),
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
