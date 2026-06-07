import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../models/order_return_request_model.dart';
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
      return 'Chuyển khoản';
    case 'e_wallet':
      return 'Ví điện tử';
    case 'credit_card':
      return 'Thẻ';
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
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OrderService>().loadAllOrdersForAdmin(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        final filteredByStatus = _status == null
            ? orderService.orders
            : orderService.orders
                  .where((order) => order.status == _status)
                  .toList();
        final normalized = _query.trim().toLowerCase();
        final orders = normalized.isEmpty
            ? filteredByStatus
            : filteredByStatus.where((order) {
                return order.orderNumber.toLowerCase().contains(normalized) ||
                    order.customerName.toLowerCase().contains(normalized) ||
                    order.phoneNumber.toLowerCase().contains(normalized) ||
                    order.trackingNumber.toLowerCase().contains(normalized);
              }).toList();

        return AdminPageScaffold(
          title: 'QUẢN LÝ\nĐƠN HÀNG',
          subtitle: 'Theo dõi, xác nhận và cập nhật trạng thái đơn',
          trailing: IconButton(
            onPressed: () => _showExportSheet(context),
            icon: Icon(Icons.download_rounded, color: AppColors.neon),
          ),
          children: [
            GlowButton(
              label: 'XUẤT CSV',
              icon: Icons.download_rounded,
              expanded: true,
              onPressed: () => _showExportSheet(context),
            ),
            const SizedBox(height: 10),
            GlowButton(
              label: 'YÊU CẦU HỦY / TRẢ HÀNG',
              icon: Icons.assignment_return_rounded,
              expanded: true,
              isPrimary: false,
              onPressed: () => _showReturnRequestsSheet(context),
            ),
            const SizedBox(height: 14),
            AdminSearchField(
              hint: 'Tìm mã đơn, tên khách hoặc số điện thoại...',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 14),
            _StatusFilter(
              selected: _status,
              onChanged: (value) => setState(() => _status = value),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            Text(
              '${orders.length} ĐƠN HÀNG',
              style: TextStyle(
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
              const AdminSectionTitle(
                eyebrow: 'Xuất dữ liệu',
                title: 'CSV đơn hàng',
              ),
              const SizedBox(height: 16),
              const _ExportOption(label: 'Các đơn đang lọc'),
              const SizedBox(height: 10),
              const _ExportOption(label: 'Đơn hàng tháng này'),
              const SizedBox(height: 10),
              const _ExportOption(label: 'Chỉ đơn chờ xử lý'),
              const SizedBox(height: 18),
              GlowButton(
                label: 'TẠO FILE CSV',
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

  void _showReturnRequestsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ReturnRequestsSheet(),
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
    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.returned) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _LockedOrderStatusPage(order: order),
        ),
      );
      return;
    }

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
      (label: 'TẤt cả', status: null),
      (label: 'Chờ xử lý', status: OrderStatus.pending),
      (label: 'Đã xác nhận', status: OrderStatus.confirmed),
      (label: 'Đang giao', status: OrderStatus.shipping),
      (label: 'Đã giao', status: OrderStatus.delivered),
      (label: 'Đã hủy', status: OrderStatus.cancelled),
      (label: 'Đã trả', status: OrderStatus.returned),
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
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              AdminStatusChip(
                label: order.status.label,
                color: order.status.color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${order.customerName.isEmpty ? 'Khách hàng' : order.customerName} / ${order.totalQuantity} sản phẩm',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.phoneNumber,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatVnd(order.total),
                  style: TextStyle(
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
            style: TextStyle(
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
        decoration: BoxDecoration(
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
            AdminSectionTitle(
              eyebrow: 'Chi tiết đơn',
              title: order.orderNumber,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Khách hàng',
              value: order.customerName.isEmpty
                  ? 'Khách hàng'
                  : order.customerName,
            ),
            _DetailRow(label: 'Điện thoại', value: order.phoneNumber),
            _DetailRow(label: 'Địa chỉ', value: order.shippingAddress),
            _DetailRow(
              label: 'Thanh toán',
              value: _paymentLabel(order.paymentMethod),
            ),
            _DetailRow(label: 'Tạm tính', value: _formatVnd(order.subtotal)),
            _DetailRow(
              label: 'Phí ship',
              value: _formatVnd(order.shippingCost),
            ),
            if (order.discount > 0)
              _DetailRow(
                label: 'Voucher',
                value: '-${_formatVnd(order.discount)}',
              ),
            _DetailRow(label: 'Tổng tiền', value: _formatVnd(order.total)),
            const SizedBox(height: 16),
            const AdminSectionTitle(eyebrow: 'Sản phẩm', title: 'Snapshot'),
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
              label: 'CẬP NHẬT TRẠNG THÁI',
              icon: Icons.sync_rounded,
              expanded: true,
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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

class _LockedOrderStatusPage extends StatelessWidget {
  const _LockedOrderStatusPage({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == OrderStatus.cancelled;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'TRẠNG THÁI ĐƠN',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SectionCard(
            color: AppColors.surface2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isCancelled
                      ? Icons.cancel_rounded
                      : Icons.assignment_return_rounded,
                  color: isCancelled ? AppColors.error : AppColors.warning,
                  size: 44,
                ),
                const SizedBox(height: 18),
                Text(
                  isCancelled ? 'Đơn hàng đã hủy' : 'Đơn hàng đã trả hàng',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${order.orderNumber} đang ở trạng thái ${order.status.label}. Admin không thể cập nhật trạng thái đơn này nữa.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                GlowButton(
                  label: 'QUAY LẠI',
                  icon: Icons.arrow_back_rounded,
                  expanded: true,
                  isPrimary: false,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
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
    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.returned) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SectionCard(
            color: AppColors.surface2,
            child: Text(
              '${order.orderNumber} đã ${order.status.label.toLowerCase()}, không thể cập nhật trạng thái.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Trạng thái', title: order.orderNumber),
            const SizedBox(height: 16),
            _StatusAction(
              label: 'Xác nhận đơn',
              icon: Icons.task_alt_rounded,
              onTap: () => _updateStatus(context, OrderStatus.confirmed),
            ),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Chuyển sang đang giao',
              icon: Icons.local_shipping_rounded,
              onTap: () => _updateStatus(context, OrderStatus.shipping),
            ),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Đánh dấu đã giao',
              icon: Icons.check_circle_rounded,
              onTap: () => _updateStatus(context, OrderStatus.delivered),
            ),
            const SizedBox(height: 10),
            _StatusAction(
              label: 'Hủy đơn',
              icon: Icons.cancel_rounded,
              color: AppColors.error,
              onTap: () => _updateStatus(context, OrderStatus.cancelled),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, OrderStatus status) async {
    await context.read<OrderService>().updateOrderStatus(
      order.id,
      status,
      note: 'Updated by admin',
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã cập nhật: ${status.label}')));
  }
}

class _ReturnRequestsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionTitle(
              eyebrow: 'Request',
              title: 'Hủy / Trả hàng',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.62,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('return_requests')
                    .snapshots(),
                builder: (context, snapshot) {
                  final requests =
                      (snapshot.data?.docs ?? []).map((doc) {
                          return OrderReturnRequestModel.fromJson({
                            ...doc.data(),
                            'id': doc.data()['id'] ?? doc.id,
                          });
                        }).toList()
                        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      requests.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.neon),
                    );
                  }

                  if (requests.isEmpty) {
                    return const _EmptyOrdersCard();
                  }

                  return ListView.separated(
                    itemCount: requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _ReturnRequestCard(request: requests[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnRequestCard extends StatelessWidget {
  const _ReturnRequestCard({required this.request});

  final OrderReturnRequestModel request;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${request.requestType.toUpperCase()} / ${request.orderId}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AdminStatusChip(label: request.status, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Reason: ${request.reason}',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Items: ${request.itemIds.length} / Refund: ${_formatVnd(request.refundAmount)}',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _StatusAction extends StatelessWidget {
  _StatusAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.neon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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
    return SectionCard(
      color: AppColors.surface2,
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: AppColors.neon, size: 42),
          SizedBox(height: 12),
          Text(
            'Chưa có đơn hàng',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Đơn hàng user checkout sẽ hiện tại đây.',
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
          Icon(Icons.table_chart_rounded, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
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
            child: Text(
              label,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
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
          Icon(Icons.inventory_2_outlined, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            'Size $size / x$qty',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
