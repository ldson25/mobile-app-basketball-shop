import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../models/user_model.dart';
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
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, usersSnapshot) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (context, ordersSnapshot) {
            final users = _parseUsers(usersSnapshot.data);
            final orders = _parseOrders(ordersSnapshot.data);
            final customers = _buildCustomers(users, orders);
            final visibleCustomers = _filterCustomers(customers);
            final loading =
                usersSnapshot.connectionState == ConnectionState.waiting ||
                    ordersSnapshot.connectionState == ConnectionState.waiting;

            return AdminPageScaffold(
              title: 'QUAN LY\nKHACH HANG',
              subtitle: 'Du lieu that tu users va orders',
              children: [
                AdminSearchField(
                  hint: 'Tim ten, email hoac so dien thoai...',
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 14),
                _CustomerSegmentFilter(
                  selected: _segment,
                  onChanged: (value) => setState(() => _segment = value),
                ),
                const SizedBox(height: AppSizes.sectionGap),
                AdminMetricCard(
                  label: 'Tong khach hang',
                  value: '${customers.length}',
                  icon: Icons.groups_rounded,
                  delta: loading ? 'Dang tai du lieu Firestore' : 'Tu users',
                ),
                const SizedBox(height: 14),
                AdminMetricCard(
                  label: 'Khach VIP',
                  value: '${customers.where((item) => item.isVip).length}',
                  icon: Icons.workspace_premium_rounded,
                  delta: 'Theo membershipTier',
                ),
                const SizedBox(height: AppSizes.sectionGap),
                Text(
                  '${visibleCustomers.length} KHACH HANG',
                  style: const TextStyle(
                    color: AppColors.neon,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                if (loading && customers.isEmpty)
                  const _CustomerLoadingCard()
                else if (visibleCustomers.isEmpty)
                  const _CustomerEmptyCard()
                else
                  ...visibleCustomers.map(
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
          },
        );
      },
    );
  }

  List<UserModel> _parseUsers(QuerySnapshot<Map<String, dynamic>>? snapshot) {
    if (snapshot == null) return [];
    return snapshot.docs.map((doc) {
      final data = {...doc.data(), 'id': doc.id};
      return _userFromData(data);
    }).toList();
  }

  List<OrderModel> _parseOrders(QuerySnapshot<Map<String, dynamic>>? snapshot) {
    if (snapshot == null) return [];
    return snapshot.docs.map((doc) {
      final data = {...doc.data(), 'id': doc.id};
      return OrderModel.fromJson(data);
    }).toList();
  }

  List<_AdminCustomer> _buildCustomers(
    List<UserModel> users,
    List<OrderModel> orders,
  ) {
    return users.map((user) {
      final userOrders = orders.where((order) => order.userId == user.id).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      final validOrders = userOrders
          .where((order) =>
              order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.returned)
          .toList();
      final totalSpent = validOrders.fold<double>(
        0,
        (sum, order) => sum + order.total,
      );

      return _AdminCustomer(
        id: user.id,
        name: user.fullName.isEmpty ? user.email : user.fullName,
        email: user.email,
        phone: user.phoneNumber ?? 'Chua cap nhat',
        role: user.role.name,
        membership: user.membershipTier.name,
        totalOrders: validOrders.length,
        totalSpent: totalSpent,
        lastOrder: validOrders.isEmpty ? null : validOrders.first.date,
      );
    }).toList()
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
  }

  List<_AdminCustomer> _filterCustomers(List<_AdminCustomer> customers) {
    Iterable<_AdminCustomer> result = customers;
    if (_segment == 'VIP') {
      result = result.where((customer) => customer.isVip);
    } else if (_segment == 'Member') {
      result = result.where((customer) => customer.membership == 'member');
    } else if (_segment == 'Admin') {
      result = result.where((customer) => customer.isAdmin);
    } else if (_segment != 'All') {
      result = result.where((customer) => customer.role == 'user');
    }

    final normalized = _query.trim().toLowerCase();
    if (normalized.isNotEmpty) {
      result = result.where((customer) {
        return customer.name.toLowerCase().contains(normalized) ||
            customer.email.toLowerCase().contains(normalized) ||
            customer.phone.toLowerCase().contains(normalized);
      });
    }
    return result.toList();
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
    const values = ['All', 'VIP', 'Member', 'Admin', 'User'];
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
              child: Icon(
                customer.isAdmin
                    ? Icons.admin_panel_settings_rounded
                    : Icons.person_rounded,
                color: customer.statusColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    '${customer.totalOrders} don / ${_money(customer.totalSpent)}',
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
            AdminStatusChip(label: customer.statusLabel, color: customer.statusColor),
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
            AdminSectionTitle(eyebrow: 'Khach hang', title: customer.name),
            const SizedBox(height: 16),
            _InfoRow(label: 'User ID', value: customer.id),
            _InfoRow(label: 'Email', value: customer.email),
            _InfoRow(label: 'So dien thoai', value: customer.phone),
            _InfoRow(label: 'Role', value: customer.role),
            _InfoRow(label: 'Membership', value: customer.membership),
            _InfoRow(label: 'Tong don', value: '${customer.totalOrders}'),
            _InfoRow(label: 'Tong chi tieu', value: _money(customer.totalSpent)),
            _InfoRow(label: 'Lan mua gan nhat', value: customer.lastOrderLabel),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _CustomerLoadingCard extends StatelessWidget {
  const _CustomerLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 14),
          Text(
            'Dang tai khach hang...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CustomerEmptyCard extends StatelessWidget {
  const _CustomerEmptyCard();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      color: AppColors.surface2,
      child: Text(
        'Chua co khach hang phu hop.',
        style: TextStyle(color: AppColors.textSecondary),
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

class _AdminCustomer {
  const _AdminCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.membership,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrder,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String membership;
  final int totalOrders;
  final double totalSpent;
  final DateTime? lastOrder;

  bool get isAdmin => role == 'admin';
  bool get isVip => membership == 'vip';

  String get statusLabel {
    if (isAdmin) return 'Admin';
    if (isVip) return 'VIP';
    return 'Member';
  }

  Color get statusColor {
    if (isAdmin) return AppColors.warning;
    if (isVip) return AppColors.neon;
    return AppColors.textSecondary;
  }

  String get lastOrderLabel {
    final value = lastOrder;
    if (value == null) return 'Chua mua hang';
    return '${value.day}/${value.month}/${value.year}';
  }
}

UserModel _userFromData(Map<String, dynamic> data) {
  return UserModel(
    id: (data['id'] ?? '').toString(),
    email: (data['email'] ?? '').toString(),
    fullName: (data['fullName'] ?? data['name'] ?? '').toString(),
    phoneNumber: data['phoneNumber']?.toString(),
    avatarUrl: data['avatarUrl']?.toString(),
    createdAt: _parseDate(data['createdAt']),
    role: UserRole.values.firstWhere(
      (role) => role.name == data['role'],
      orElse: () => UserRole.user,
    ),
    membershipTier: MembershipTier.values.firstWhere(
      (tier) => tier.name == data['membershipTier'],
      orElse: () => MembershipTier.member,
    ),
  );
}

DateTime _parseDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.tryParse((value ?? '').toString()) ?? DateTime.now();
}

String _money(double value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer}d';
}
