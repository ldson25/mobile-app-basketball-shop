import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminCustomerManagementPage extends StatefulWidget {
  const AdminCustomerManagementPage({super.key});

  @override
  State<AdminCustomerManagementPage> createState() =>
      _AdminCustomerManagementPageState();
}

class _AdminCustomerManagementPageState
    extends State<AdminCustomerManagementPage> {
  String _segment = 'Tất cả';

  final List<_AdminCustomer> _customers = const [
    _AdminCustomer(
      name: 'Nguyễn Minh',
      email: 'marcus@kinetic.app',
      phone: '0901000001',
      status: 'VIP',
      color: AppColors.neon,
      totalOrders: 12,
      totalSpent: '71.000.000đ',
      lastOrder: '24/10/2023',
    ),
    _AdminCustomer(
      name: 'Trần Hoàng',
      email: 'elena@kinetic.app',
      phone: '0901000002',
      status: 'Member',
      color: AppColors.neon,
      totalOrders: 5,
      totalSpent: '24.500.000đ',
      lastOrder: '23/10/2023',
    ),
    _AdminCustomer(
      name: 'Lê Quốc',
      email: 'jordan@kinetic.app',
      phone: '0901000003',
      status: 'Member',
      color: AppColors.warning,
      totalOrders: 2,
      totalSpent: '8.875.000đ',
      lastOrder: '21/10/2023',
    ),
    _AdminCustomer(
      name: 'Phạm An',
      email: 'liam@kinetic.app',
      phone: '0901000004',
      status: 'Đã khóa',
      color: AppColors.error,
      totalOrders: 1,
      totalSpent: '3.000.000đ',
      lastOrder: '20/10/2023',
    ),
  ];

  List<_AdminCustomer> get _visibleCustomers {
    if (_segment == 'Tất cả') return _customers;
    return _customers.where((customer) => customer.status == _segment).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customers = _visibleCustomers;

    return AdminPageScaffold(
      title: 'QUẢN LÝ\nKHÁCH HÀNG',
      subtitle: 'Hồ sơ, hạng thành viên và lịch sử đơn hàng',
      children: [
        const AdminSearchField(hint: 'Tìm tên, email hoặc số điện thoại...'),
        const SizedBox(height: 14),
        _CustomerSegmentFilter(
          selected: _segment,
          onChanged: (value) => setState(() => _segment = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminMetricCard(
          label: 'Tổng khách hàng',
          value: '1.284',
          icon: Icons.groups_rounded,
          delta: '+36 khách hàng tuần này',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Khách VIP',
          value: '218',
          icon: Icons.workspace_premium_rounded,
          delta: 'Nhóm ưu đãi thành viên',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Text(
          '${customers.length} KHÁCH HÀNG',
          style: const TextStyle(
            color: AppColors.neon,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        ...customers.map(
          (customer) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CustomerCard(
              customer: customer,
              onTap: () => _showCustomerDetail(context, customer),
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomerDetail(BuildContext context, _AdminCustomer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CustomerDetailSheet(customer: customer),
    );
  }
}

class _CustomerSegmentFilter extends StatelessWidget {
  const _CustomerSegmentFilter({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const values = ['Tất cả', 'VIP', 'Member', 'Đã khóa'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final value = values[index];
          final active = value == selected;
          return GestureDetector(
            onTap: () => onChanged(value),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: active ? AppColors.neon : AppColors.surface2,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? AppColors.neon : AppColors.border,
                ),
              ),
              child: Text(
                value.toUpperCase(),
                style: TextStyle(
                  color: active ? AppColors.background : AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer, required this.onTap});

  final _AdminCustomer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SectionCard(
        color: AppColors.surface2,
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.surfaceHighest,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border.withOpacity(0.35)),
              ),
              child: const Icon(Icons.person_rounded, color: AppColors.neon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${customer.totalOrders} đơn / ${customer.totalSpent}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            AdminStatusChip(label: customer.status, color: customer.color),
          ],
        ),
      ),
    );
  }
}

class _CustomerDetailSheet extends StatelessWidget {
  const _CustomerDetailSheet({required this.customer});

  final _AdminCustomer customer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminSectionTitle(eyebrow: 'Khách hàng', title: customer.name),
            const SizedBox(height: 16),
            _InfoRow(label: 'Email', value: customer.email),
            _InfoRow(label: 'Số điện thoại', value: customer.phone),
            _InfoRow(label: 'Tổng đơn', value: '${customer.totalOrders}'),
            _InfoRow(label: 'Tổng chi tiêu', value: customer.totalSpent),
            _InfoRow(label: 'Đơn gần nhất', value: customer.lastOrder),
            const SizedBox(height: 18),
            const AdminSectionTitle(eyebrow: 'Thao tác nhanh', title: 'Tài khoản'),
            const SizedBox(height: 12),
            _CustomerAction(
              icon: Icons.receipt_long_rounded,
              label: 'Xem lịch sử đơn hàng',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            _CustomerAction(
              icon: Icons.workspace_premium_rounded,
              label: 'Chuyển hạng Member / VIP',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            _CustomerAction(
              icon: Icons.admin_panel_settings_rounded,
              label: 'Đổi quyền truy cập',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            _CustomerAction(
              icon: Icons.block_rounded,
              label: customer.status == 'Đã khóa'
                  ? 'Mở khóa khách hàng'
                  : 'Khóa khách hàng',
              color: AppColors.error,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: 'LƯU KHÁCH HÀNG',
              icon: Icons.save_rounded,
              expanded: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerAction extends StatelessWidget {
  const _CustomerAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.neon,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SectionCard(
        color: AppColors.surface2,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color),
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
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textMuted)),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminCustomer {
  const _AdminCustomer({
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.color,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrder,
  });

  final String name;
  final String email;
  final String phone;
  final String status;
  final Color color;
  final int totalOrders;
  final String totalSpent;
  final String lastOrder;
}
