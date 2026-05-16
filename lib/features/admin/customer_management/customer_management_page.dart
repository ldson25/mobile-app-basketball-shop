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
  String _segment = 'All';

  final List<_AdminCustomer> _customers = const [
    _AdminCustomer(
      name: 'Marcus V.',
      email: 'marcus@kinetic.app',
      phone: '0901000001',
      status: 'VIP',
      color: AppColors.neon,
      totalOrders: 12,
      totalSpent: '\$2.840',
      lastOrder: 'OCT 24, 2023',
    ),
    _AdminCustomer(
      name: 'Elena S.',
      email: 'elena@kinetic.app',
      phone: '0901000002',
      status: 'Active',
      color: AppColors.neon,
      totalOrders: 5,
      totalSpent: '\$980',
      lastOrder: 'OCT 23, 2023',
    ),
    _AdminCustomer(
      name: 'Jordan K.',
      email: 'jordan@kinetic.app',
      phone: '0901000003',
      status: 'New',
      color: AppColors.warning,
      totalOrders: 2,
      totalSpent: '\$355',
      lastOrder: 'OCT 21, 2023',
    ),
    _AdminCustomer(
      name: 'Liam W.',
      email: 'liam@kinetic.app',
      phone: '0901000004',
      status: 'Blocked',
      color: AppColors.error,
      totalOrders: 1,
      totalSpent: '\$120',
      lastOrder: 'OCT 20, 2023',
    ),
  ];

  List<_AdminCustomer> get _visibleCustomers {
    if (_segment == 'All') return _customers;
    return _customers.where((customer) => customer.status == _segment).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customers = _visibleCustomers;

    return AdminPageScaffold(
      title: 'CUSTOMER\nMANAGEMENT',
      subtitle: 'Profiles, membership and order history',
      children: [
        const AdminSearchField(hint: 'Search name, email or phone number...'),
        const SizedBox(height: 14),
        _CustomerSegmentFilter(
          selected: _segment,
          onChanged: (value) => setState(() => _segment = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminMetricCard(
          label: 'Total customers',
          value: '1.284',
          icon: Icons.groups_rounded,
          delta: '+36 customers this week',
        ),
        const SizedBox(height: 14),
        const AdminMetricCard(
          label: 'Early access',
          value: '218',
          icon: Icons.workspace_premium_rounded,
          delta: 'Priority launch group',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Text(
          '${customers.length} CUSTOMERS',
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
    const values = ['All', 'VIP', 'Active', 'New', 'Blocked'];
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
                    '${customer.totalOrders} ORDERS / ${customer.totalSpent}',
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
            AdminSectionTitle(eyebrow: 'Customer', title: customer.name),
            const SizedBox(height: 16),
            _InfoRow(label: 'Email', value: customer.email),
            _InfoRow(label: 'Phone', value: customer.phone),
            _InfoRow(label: 'Total orders', value: '${customer.totalOrders}'),
            _InfoRow(label: 'Total spent', value: customer.totalSpent),
            _InfoRow(label: 'Last order', value: customer.lastOrder),
            const SizedBox(height: 18),
            const AdminSectionTitle(eyebrow: 'Quick actions', title: 'Account'),
            const SizedBox(height: 12),
            _CustomerAction(
              icon: Icons.receipt_long_rounded,
              label: 'View order history',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            _CustomerAction(
              icon: Icons.workspace_premium_rounded,
              label: 'Mark as VIP / Early access',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            _CustomerAction(
              icon: Icons.admin_panel_settings_rounded,
              label: 'Change role',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            _CustomerAction(
              icon: Icons.block_rounded,
              label: customer.status == 'Blocked'
                  ? 'Unblock customer'
                  : 'Block customer',
              color: AppColors.error,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: 'SAVE CUSTOMER',
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
