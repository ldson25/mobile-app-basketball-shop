import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminOrderManagementPage extends StatefulWidget {
  const AdminOrderManagementPage({super.key});

  @override
  State<AdminOrderManagementPage> createState() =>
      _AdminOrderManagementPageState();
}

class _AdminOrderManagementPageState extends State<AdminOrderManagementPage> {
  String _status = 'All';

  final List<_AdminOrder> _orders = const [
    _AdminOrder(
      id: '#ORD-8821',
      customer: 'Marcus V.',
      email: 'marcus@kinetic.app',
      itemCount: 2,
      amount: '\$340.00',
      date: 'OCT 24, 2023 / 14:22',
      status: 'Pending',
      color: AppColors.warning,
      payment: 'COD',
    ),
    _AdminOrder(
      id: '#ORD-8790',
      customer: 'Elena S.',
      email: 'elena@kinetic.app',
      itemCount: 1,
      amount: '\$185.50',
      date: 'OCT 23, 2023 / 09:15',
      status: 'Confirmed',
      color: AppColors.neon,
      payment: 'Bank transfer',
    ),
    _AdminOrder(
      id: '#ORD-8742',
      customer: 'Jordan K.',
      email: 'jordan@kinetic.app',
      itemCount: 3,
      amount: '\$590.00',
      date: 'OCT 21, 2023 / 18:45',
      status: 'Shipping',
      color: AppColors.textSecondary,
      payment: 'E-wallet',
    ),
    _AdminOrder(
      id: '#ORD-8711',
      customer: 'Liam W.',
      email: 'liam@kinetic.app',
      itemCount: 1,
      amount: '\$120.00',
      date: 'OCT 20, 2023 / 11:00',
      status: 'Cancelled',
      color: AppColors.error,
      payment: 'COD',
    ),
  ];

  List<_AdminOrder> get _visibleOrders {
    if (_status == 'All') return _orders;
    return _orders.where((order) => order.status == _status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final orders = _visibleOrders;

    return AdminPageScaffold(
      title: 'ORDER\nMANAGEMENT',
      subtitle: 'Payment, shipping and fulfillment',
      trailing: IconButton(
        onPressed: () => _showExportSheet(context),
        icon: const Icon(Icons.download_rounded, color: AppColors.neon),
      ),
      children: [
        GlowButton(
          label: 'EXPORT CSV',
          icon: Icons.download_rounded,
          expanded: true,
          onPressed: () => _showExportSheet(context),
        ),
        const SizedBox(height: 14),
        const AdminSearchField(hint: 'Search order number, email or phone...'),
        const SizedBox(height: 14),
        _StatusFilter(
          selected: _status,
          onChanged: (value) => setState(() => _status = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Text(
          '${orders.length} ORDERS',
          style: const TextStyle(
            color: AppColors.neon,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        ...orders.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _AdminOrderCard(
              order: order,
              onView: () => _showOrderDetail(context, order),
              onStatus: () => _showStatusSheet(context, order),
            ),
          ),
        ),
      ],
    );
  }

  void _showExportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AdminSectionTitle(eyebrow: 'Export', title: 'Order CSV'),
              const SizedBox(height: 16),
              const _ExportOption(label: 'Current filtered orders'),
              const SizedBox(height: 10),
              const _ExportOption(label: 'This month orders'),
              const SizedBox(height: 10),
              const _ExportOption(label: 'Pending orders only'),
              const SizedBox(height: 18),
              GlowButton(
                label: 'GENERATE CSV',
                icon: Icons.file_download_rounded,
                expanded: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetail(BuildContext context, _AdminOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _OrderDetailSheet(order: order),
    );
  }

  void _showStatusSheet(BuildContext context, _AdminOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _StatusActionSheet(order: order),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const values = ['All', 'Pending', 'Confirmed', 'Shipping', 'Cancelled'];
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

class _AdminOrderCard extends StatelessWidget {
  const _AdminOrderCard({
    required this.order,
    required this.onView,
    required this.onStatus,
  });

  final _AdminOrder order;
  final VoidCallback onView;
  final VoidCallback onStatus;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              AdminStatusChip(label: order.status, color: order.color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${order.customer} / ${order.itemCount} items',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            order.email,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.amount,
                  style: const TextStyle(
                    color: AppColors.neon,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AdminStatusChip(label: order.payment, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            order.date,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(icon: Icons.remove_red_eye_outlined, onTap: onView),
              const SizedBox(width: 12),
              _ActionButton(icon: Icons.local_shipping_outlined, onTap: onStatus),
              const SizedBox(width: 12),
              _ActionButton(icon: Icons.close_rounded, onTap: onStatus),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.surfaceHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}

class _OrderDetailSheet extends StatelessWidget {
  const _OrderDetailSheet({required this.order});

  final _AdminOrder order;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Order detail', title: order.id),
            const SizedBox(height: 16),
            _DetailRow(label: 'Customer', value: order.customer),
            _DetailRow(label: 'Email', value: order.email),
            _DetailRow(label: 'Payment', value: order.payment),
            _DetailRow(label: 'Amount', value: order.amount),
            _DetailRow(label: 'Date', value: order.date),
            const SizedBox(height: 16),
            const AdminSectionTitle(eyebrow: 'Items', title: 'Snapshot'),
            const SizedBox(height: 12),
            const _OrderItemPreview(name: 'Hypervolt v1', size: '10', qty: 1),
            SizedBox(height: 10),
            const _OrderItemPreview(name: 'Kinetic Jersey', size: 'M', qty: 1),
            const SizedBox(height: 18),
            GlowButton(
              label: 'UPDATE STATUS',
              icon: Icons.sync_rounded,
              expanded: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusActionSheet extends StatelessWidget {
  const _StatusActionSheet({required this.order});

  final _AdminOrder order;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Status', title: order.id),
            const SizedBox(height: 16),
            const _StatusAction(label: 'Confirm order', icon: Icons.task_alt_rounded),
            const SizedBox(height: 10),
            const _StatusAction(label: 'Mark as shipping', icon: Icons.local_shipping_rounded),
            const SizedBox(height: 10),
            const _StatusAction(label: 'Mark as delivered', icon: Icons.check_circle_rounded),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Cancel order',
              icon: Icons.cancel_rounded,
              color: AppColors.error,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusAction extends StatelessWidget {
  const _StatusAction({
    required this.label,
    required this.icon,
    this.color = AppColors.neon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap ?? () => Navigator.pop(context),
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

class _ExportOption extends StatelessWidget {
  const _ExportOption({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.table_chart_rounded, color: AppColors.neon),
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
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

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

class _OrderItemPreview extends StatelessWidget {
  const _OrderItemPreview({
    required this.name,
    required this.size,
    required this.qty,
  });

  final String name;
  final String size;
  final int qty;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text('Size $size / x$qty', style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _AdminOrder {
  const _AdminOrder({
    required this.id,
    required this.customer,
    required this.email,
    required this.itemCount,
    required this.amount,
    required this.date,
    required this.status,
    required this.color,
    required this.payment,
  });

  final String id;
  final String customer;
  final String email;
  final int itemCount;
  final String amount;
  final String date;
  final String status;
  final Color color;
  final String payment;
}
