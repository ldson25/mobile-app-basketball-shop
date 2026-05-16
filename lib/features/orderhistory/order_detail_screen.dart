import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/order_service.dart';
import '../../../models/order_model.dart';
import '../cart/mycart.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _OrderDetailAppBar(),
      body: Consumer<OrderService>(
        builder: (context, orderService, child) {
          final order = orderService.getOrderById(orderId);
          
          if (order == null) {
            return const Center(
              child: Text(
                'Order not found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Status Card
                  _OrderStatusCard(order: order),
                  const SizedBox(height: 24),
                  
                  // Order Info
                  _OrderInfoCard(order: order),
                  const SizedBox(height: 24),
                  
                  // Shipping Info
                  _ShippingInfoCard(order: order),
                  const SizedBox(height: 24),
                  
                  // Products List
                  _ProductsList(order: order),
                  const SizedBox(height: 24),
                  
                  // Payment Summary
                  _PaymentSummary(order: order),
                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  _ActionButtons(order: order),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
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
        'ORDER DETAILS',
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
          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
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
  final OrderModel order;

  const _OrderStatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isPending = order.status == OrderStatus.pending;
    final isDelivered = order.status == OrderStatus.delivered;
    final isCancelled = order.status == OrderStatus.cancelled;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            order.status.color.withOpacity(0.1),
            AppColors.surface2,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: order.status.color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: order.status.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPending ? Icons.pending_actions :
                  isDelivered ? Icons.check_circle :
                  Icons.cancel,
                  color: order.status.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.status.label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: order.status.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPending ? 'Your order has been confirmed' :
                      isDelivered ? 'Your order has been delivered' :
                      'Your order has been cancelled',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: 0.3,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neon),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Order Placed', style: TextStyle(fontSize: 10, color: AppColors.neon)),
                Text('Processing', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                Text('Shipped', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                Text('Delivered', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  final OrderModel order;

  const _OrderInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER INFORMATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            label: 'Order Number',
            value: order.orderNumber,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Order Date',
            value: order.formattedDate,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Tracking Number',
            value: order.trackingNumber,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Payment Method',
            value: 'Cash on Delivery', // Có thể lấy từ payment data
          ),
        ],
      ),
    );
  }
}

class _ShippingInfoCard extends StatelessWidget {
  final OrderModel order;

  const _ShippingInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SHIPPING INFORMATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.neon.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_shipping, color: AppColors.neon, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.shippingAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.phoneNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  final OrderModel order;

  const _ProductsList({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ORDER ITEMS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${order.totalQuantity} items',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _OrderItemCard(item: item),
          )),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final dynamic item; // CartItemModel

  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Product Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surface3,
                child: const Icon(
                  Icons.image_not_supported,
                  color: AppColors.textSecondary,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Product Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Size: ${item.size} | Qty: ${item.quantity}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neon,
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
  final OrderModel order;

  const _PaymentSummary({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Text(
            'PAYMENT SUMMARY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${order.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Shipping',
            value: order.shippingCost > 0 
                ? '\$${order.shippingCost.toStringAsFixed(2)}' 
                : 'FREE',
          ),
          const Divider(color: AppColors.border, height: 24),
          _SummaryRow(
            label: 'TOTAL',
            value: '\$${order.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? Colors.white : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.neon : Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final OrderModel order;

  const _ActionButtons({required this.order});

  @override
  Widget build(BuildContext context) {
    final isPending = order.status == OrderStatus.pending;
    final isDelivered = order.status == OrderStatus.delivered;

    return Column(
      children: [
        if (isPending)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Cancel order logic
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text(
                      'Cancel Order',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Are you sure you want to cancel this order?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('NO'),
                      ),
                      TextButton(
                        onPressed: () {
                          final orderService = Provider.of<OrderService>(
                            context,
                            listen: false,
                          );
                          orderService.updateOrderStatus(
                            order.id,
                            OrderStatus.cancelled,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order cancelled'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'YES',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
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
                'CANCEL ORDER',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        if (isPending) const SizedBox(height: 12),
        if (isDelivered)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Buy again logic - add all items to cart
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Items added to cart'),
                    duration: Duration(seconds: 2),
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
                'BUY AGAIN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neon,
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neon,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'BACK TO ORDERS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}