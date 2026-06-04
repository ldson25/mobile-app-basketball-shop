import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../services/order_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

String _formatVnd(double value) {
  final number = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < number.length; i++) {
    final fromEnd = number.length - i;
    buffer.write(number[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer}d';
}

String _paymentLabel(String method) {
  switch (method) {
    case 'bank_transfer':
      return 'Chuyen khoan';
    case 'e_wallet':
      return 'Vi dien tu';
    case 'credit_card':
      return 'The';
    case 'cash':
    default:
      return 'COD';
  }
}

class AdminOrderManagementPage extends StatefulWidget {
  const AdminOrderManagementPage({super.key});

  @override
  State<AdminOrderManagementPage> createState() =>
      _AdminOrderManagementPageState();
}

class _AdminOrderManagementPageState extends State<AdminOrderManagementPage> {
  OrderStatus? _status;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        final orders = _status == null
            ? orderService.orders
            : orderService.orders
                .where((order) => order.status == _status)
                .toList();

        return AdminPageScaffold(
          title: 'QUAN LY\nDON HANG',
          subtitle: 'Theo doi, xac nhan va cap nhat trang thai don',
          trailing: IconButton(
            onPressed: () => _showExportSheet(context),
            icon: const Icon(Icons.download_rounded, color: AppColors.neon),
          ),
          children: [
            GlowButton(
              label: 'XUAT CSV',
              icon: Icons.download_rounded,
              expanded: true,
              onPressed: () => _showExportSheet(context),
            ),
            const SizedBox(height: 14),
            const AdminSearchField(hint: 'Tim ma don, ten khach hoac so dien thoai...'),
            const SizedBox(height: 14),
            _StatusFilter(
              selected: _status,
              onChanged: (value) => setState(() => _status = value),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            Text(
              '${orders.length} DON HANG',
              style: const TextStyle(
                color: AppColors.neon,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            if (orders.isEmpty)
              const _EmptyOrdersCard()
            else
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
      },
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
              const AdminSectionTitle(eyebrow: 'Xuat du lieu', title: 'CSV don hang'),
              const SizedBox(height: 16),
              const _ExportOption(label: 'Cac don dang loc'),
              const SizedBox(height: 10),
              const _ExportOption(label: 'Don hang thang nay'),
              const SizedBox(height: 10),
              const _ExportOption(label: 'Chi don cho xu ly'),
              const SizedBox(height: 18),
              GlowButton(
                label: 'TAO FILE CSV',
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

  void _showOrderDetail(BuildContext context, OrderModel order) {
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

  void _showStatusSheet(BuildContext context, OrderModel order) {
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

  final OrderStatus? selected;
  final ValueChanged<OrderStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = <({String label, OrderStatus? status})>[
      (label: 'Tat ca', status: null),
      (label: 'Cho xu ly', status: OrderStatus.pending),
      (label: 'Da xac nhan', status: OrderStatus.confirmed),
      (label: 'Dang giao', status: OrderStatus.shipping),
      (label: 'Da giao', status: OrderStatus.delivered),
      (label: 'Da huy', status: OrderStatus.cancelled),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final value = values[index];
          final active = value.status == selected;
          return GestureDetector(
            onTap: () => onChanged(value.status),
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
                value.label.toUpperCase(),
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

  final OrderModel order;
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
                  order.orderNumber,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              AdminStatusChip(label: order.status.label, color: order.status.color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${order.customerName.isEmpty ? 'Khach hang' : order.customerName} / ${order.totalQuantity} san pham',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            order.phoneNumber,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatVnd(order.total),
                  style: const TextStyle(
                    color: AppColors.neon,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AdminStatusChip(
                label: _paymentLabel(order.paymentMethod),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            order.formattedDate,
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
              _ActionButton(icon: Icons.sync_rounded, onTap: onStatus),
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

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Chi tiet don', title: order.orderNumber),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Khach hang',
              value: order.customerName.isEmpty ? 'Khach hang' : order.customerName,
            ),
            _DetailRow(label: 'Dien thoai', value: order.phoneNumber),
            _DetailRow(label: 'Dia chi', value: order.shippingAddress),
            _DetailRow(label: 'Thanh toan', value: _paymentLabel(order.paymentMethod)),
            _DetailRow(label: 'Tam tinh', value: _formatVnd(order.subtotal)),
            _DetailRow(label: 'Phi ship', value: _formatVnd(order.shippingCost)),
            if (order.discount > 0)
              _DetailRow(label: 'Voucher', value: '-${_formatVnd(order.discount)}'),
            _DetailRow(label: 'Tong tien', value: _formatVnd(order.total)),
            const SizedBox(height: 16),
            const AdminSectionTitle(eyebrow: 'San pham', title: 'Snapshot'),
            const SizedBox(height: 12),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OrderItemPreview(
                  name: item.title,
                  size: item.size,
                  qty: item.quantity,
                ),
              ),
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: 'CAP NHAT TRANG THAI',
              icon: Icons.sync_rounded,
              expanded: true,
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => _StatusActionSheet(order: order),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusActionSheet extends StatelessWidget {
  const _StatusActionSheet({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Trang thai', title: order.orderNumber),
            const SizedBox(height: 16),
            _StatusAction(
              label: 'Xac nhan don',
              icon: Icons.task_alt_rounded,
              onTap: () => _updateStatus(context, OrderStatus.confirmed),
            ),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Chuyen sang dang giao',
              icon: Icons.local_shipping_rounded,
              onTap: () => _updateStatus(context, OrderStatus.shipping),
            ),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Danh dau da giao',
              icon: Icons.check_circle_rounded,
              onTap: () => _updateStatus(context, OrderStatus.delivered),
            ),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Huy don',
              icon: Icons.cancel_rounded,
              color: AppColors.error,
              onTap: () => _updateStatus(context, OrderStatus.cancelled),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(BuildContext context, OrderStatus status) {
    context.read<OrderService>().updateOrderStatus(order.id, status);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Da cap nhat: ${status.label}')),
    );
  }
}

class _StatusAction extends StatelessWidget {
  const _StatusAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.neon,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
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

class _EmptyOrdersCard extends StatelessWidget {
  const _EmptyOrdersCard();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      color: AppColors.surface2,
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: AppColors.neon, size: 42),
          SizedBox(height: 12),
          Text(
            'Chua co don hang',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Don hang user checkout se hien tai day.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textMuted)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
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
