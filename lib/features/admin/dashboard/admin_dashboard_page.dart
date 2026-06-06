import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../services/order_service.dart';
import '../../../services/product_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OrderService>().loadAllOrdersForAdmin(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderService = context.watch<OrderService>();
    final productService = context.watch<ProductService>();
    final orders = orderService.orders;
    final products = productService.adminProducts;
    final todayOrders = orders.where(_isToday).toList();
    final todayRevenue = todayOrders
        .where(
          (order) =>
              order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.returned,
        )
        .fold<double>(0, (sum, order) => sum + order.total);
    final pendingOrders = orders
        .where((order) => order.status == OrderStatus.pending)
        .length;
    final lowStockProducts = products
        .where((product) => product.stockQuantity <= 10)
        .toList();

    return AdminPageScaffold(
      title: 'TỔNG QUAN\nADMIN',
      subtitle: 'Theo dõi hoạt động của cửa hàng theo dữ liệu Firestore',
      children: [
        GlowButton(
          label: 'TẢI LẠI BÁO CÁO',
          icon: Icons.refresh_rounded,
          expanded: true,
          onPressed: () => context.read<OrderService>().loadAllOrdersForAdmin(),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        AdminMetricCard(
          label: 'Doanh thu hôm nay',
          value: _formatVnd(todayRevenue),
          icon: Icons.bolt_rounded,
          delta: '${todayOrders.length} đơn trong ngày',
        ),
        const SizedBox(height: 14),
        AdminMetricCard(
          label: 'Đơn chờ xử lý',
          value: '$pendingOrders',
          icon: Icons.receipt_long_rounded,
          delta: pendingOrders == 0
              ? 'Không có đơn cần xử lý'
              : '$pendingOrders đơn cần xác nhận',
        ),
        const SizedBox(height: 14),
        AdminMetricCard(
          label: 'Sản phẩm sắp hết hàng',
          value: '${lowStockProducts.length}',
          icon: Icons.inventory_2_outlined,
          delta: lowStockProducts.isEmpty
              ? 'tồn kho đang ổn định'
              : lowStockProducts.take(2).map((item) => item.name).join(', '),
        ),
        const SizedBox(height: 14),
        _NewCustomersMetric(),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Vận Hành', title: 'Việc cần xử lý'),
        const SizedBox(height: 14),
        _ActionQueueCard(
          title: 'ác nhận đơn chờ xử lý',
          detail: '$pendingOrders đơn hàng đang chờ admin xác nhận',
          icon: Icons.task_alt_rounded,
          color: pendingOrders == 0
              ? AppColors.textSecondary
              : AppColors.warning,
        ),
        const SizedBox(height: 12),
        _ActionQueueCard(
          title: 'Nhập thêm hàng tồn thấp',
          detail: lowStockProducts.isEmpty
              ? 'Không có sản phẩm tồn kho thấp'
              : lowStockProducts.take(3).map((item) => item.name).join(', '),
          icon: Icons.inventory_rounded,
          color: lowStockProducts.isEmpty
              ? AppColors.textSecondary
              : AppColors.error,
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(
          eyebrow: 'Đơn gần đáo hạn',
          title: 'Hoạt động mới nhất',
        ),
        const SizedBox(height: 14),
        if (orders.isEmpty)
          const _EmptyActivityCard()
        else
          ...orders
              .take(3)
              .map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ActivityLogTile(
                    actor: order.customerName.isEmpty
                        ? (order.userId ?? 'user')
                        : order.customerName,
                    action:
                        'da tao don ${order.orderNumber} - ${order.status.label}',
                    time: order.formattedDate,
                  ),
                ),
              ),
      ],
    );
  }

  bool _isToday(OrderModel order) {
    final now = DateTime.now();
    return order.date.year == now.year &&
        order.date.month == now.month &&
        order.date.day == now.day;
  }
}

class _NewCustomersMetric extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        final users = snapshot.data?.docs ?? [];
        final newToday = users.where((doc) {
          final createdAt = doc.data()['createdAt'];
          final date = DateTime.tryParse((createdAt ?? '').toString());
          if (date == null) return false;
          final now = DateTime.now();
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        }).length;

        return AdminMetricCard(
          label: 'Khách hàng mới',
          value: '$newToday',
          icon: Icons.groups_rounded,
          delta: '${users.length} tong tai khoan',
        );
      },
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
                Text(
                  detail,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
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
            child: Icon(Icons.receipt_long_rounded, size: 18),
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
                Text(
                  action,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivityCard extends StatelessWidget {
  const _EmptyActivityCard();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      color: AppColors.surface2,
      child: Text(
        'Chua co don hang nao.',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

String _formatVnd(double value) {
  final number = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < number.length; i++) {
    final fromEnd = number.length - i;
    buffer.write(number[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return '${buffer}d';
}
