import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../cart/mycart.dart';
import 'cancel_order_screen.dart';
import 'return_order_screen.dart';

String formatVnd(double value) {
  final number = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < number.length; i++) {
    final fromEnd = number.length - i;
    buffer.write(number[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return '${buffer}đ';
}

String _paymentLabel(String method) {
  switch (method) {
    case 'bank_transfer':
      return 'Chuyển khoản ngân hàng';
    case 'e_wallet':
      return 'Ví điện tử';
    case 'credit_card':
      return 'Thẻ tín dụng / ghi nợ';
    case 'cash':
    default:
      return 'Thanh toán khi nhận hàng';
  }
}

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _OrderDetailAppBar(),
      body: Consumer<OrderService>(
        builder: (context, orderService, child) {
          final order = orderService.getOrderById(orderId);

          if (order == null) {
            return const Center(
              child: Text(
                'Không tìm thấy đơn hàng',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            child: Column(
              children: [
                _OrderStatusCard(order: order),
                const SizedBox(height: 18),
                _OrderInfoCard(order: order),
                const SizedBox(height: 18),
                _ShippingInfoCard(order: order),
                const SizedBox(height: 18),
                _ProductsList(order: order),
                const SizedBox(height: 18),
                _PaymentSummary(order: order),
                const SizedBox(height: 28),
                _ActionButtons(order: order),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _OrderDetailAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'CHI TIET DON',
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: AppColors.neon,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isPending = order.status == OrderStatus.pending;
    final isConfirmed = order.status == OrderStatus.confirmed;
    final isShipping = order.status == OrderStatus.shipping;
    final isDelivered = order.status == OrderStatus.delivered;
    final isActive = isPending || isConfirmed || isShipping;
    final progressValue = isPending
        ? 0.25
        : isConfirmed
        ? 0.5
        : isShipping
        ? 0.75
        : 1.0;

    final statusMessage = isPending
        ? 'Đơn hàng đang chờ xử lý'
        : isConfirmed
        ? 'Đơn hàng đã được xác nhận'
        : isShipping
        ? 'Đơn hàng đang được giao'
        : isDelivered
        ? 'Đơn hàng đã giao thành công'
        : 'Đơn hàng đã bị hủy';

    final icon = isPending
        ? Icons.pending_actions
        : isConfirmed
        ? Icons.task_alt_rounded
        : isShipping
        ? Icons.local_shipping_rounded
        : isDelivered
        ? Icons.check_circle
        : Icons.cancel;

    return _Card(
      borderColor: order.status.color.withOpacity(0.35),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: order.status.color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: order.status.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.status.label.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: order.status.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusMessage,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neon),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProgressLabel('Đã đặt'),
                _ProgressLabel('Xử lý'),
                _ProgressLabel('Đang giao'),
                _ProgressLabel('Đã giao'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('THÔNG TIN ĐƠN HÀNG'),
          const SizedBox(height: 16),
          _InfoRow(label: 'Mã đơn', value: order.orderNumber),
          _InfoRow(label: 'Ngày đặt', value: order.formattedDate),
          _InfoRow(label: 'Mã vận đơn', value: order.trackingNumber),
          _InfoRow(
            label: 'Thanh toán',
            value: _paymentLabel(order.paymentMethod),
          ),
        ],
      ),
    );
  }
}

class _ShippingInfoCard extends StatelessWidget {
  const _ShippingInfoCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('THÔNG TIN GIAO HÀNG'),
          const SizedBox(height: 16),
          _InfoRow(
            label: 'Người nhận',
            value: order.customerName.isEmpty
                ? 'Khách hàng'
                : order.customerName,
          ),
          _InfoRow(label: 'Địa chỉ', value: order.shippingAddress),
          _InfoRow(label: 'Số điện thoại', value: order.phoneNumber),
        ],
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: _SectionTitle('SẢN PHẨM TRONG ĐƠN')),
              Text(
                '${order.totalQuantity} sản phẩm',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _OrderItemCard(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            item.imagePath,
            width: 74,
            height: 74,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 74,
              height: 74,
              color: AppColors.surface3,
              child: const Icon(
                Icons.image_not_supported,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Size: ${item.size} / SL: ${item.quantity}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatVnd(item.price * item.quantity),
                style: const TextStyle(
                  color: AppColors.neon,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          const _SectionTitle('TỔNG HỢP THANH TOÁN'),
          const SizedBox(height: 16),
          _InfoRow(label: 'Tạm tính', value: formatVnd(order.subtotal)),
          _InfoRow(
            label: 'Phí giao hàng',
            value: order.shippingCost > 0
                ? formatVnd(order.shippingCost)
                : 'Miễn phí',
          ),
          if (order.discount > 0)
            _InfoRow(
              label: order.voucherCode == null
                  ? 'Voucher'
                  : 'Voucher ${order.voucherCode}',
              value: '-${formatVnd(order.discount)}',
            ),
          const Divider(color: AppColors.border, height: 24),
          _InfoRow(
            label: 'Tổng cộng',
            value: formatVnd(order.total),
            isStrong: true,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isPending = order.status == OrderStatus.pending;
    final isDelivered = order.status == OrderStatus.delivered;
    final isCancelled = order.status == OrderStatus.cancelled;

    return Column(
      children: [
        if (isPending && !isCancelled)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancelOrderScreen(order: order),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'HUY DON',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        if (isDelivered && !isCancelled)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReturnOrderScreen(order: order),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.neon),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'YEU CAU TRA HANG',
                style: TextStyle(
                  color: AppColors.neon,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        if ((isPending || isDelivered) && !isCancelled)
          const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neon,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              isDelivered ? 'Đã nhận hàng' : 'Quay lại đơn hàng',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.borderColor});

  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isStrong
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: isStrong ? 16 : 14,
                fontWeight: isStrong ? FontWeight.w900 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              style: TextStyle(
                color: isStrong ? AppColors.neon : AppColors.textPrimary,
                fontSize: isStrong ? 18 : 14,
                fontWeight: isStrong ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  const _ProgressLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
      ),
    );
  }
}
