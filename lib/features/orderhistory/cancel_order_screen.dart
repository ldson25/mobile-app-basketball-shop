import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../services/order_service.dart';

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

class CancelOrderScreen extends StatefulWidget {
  final OrderModel order;
  const CancelOrderScreen({super.key, required this.order});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();
  Map<String, bool> _selectedItems = {}; // key = item.id
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.order.items) {
      _selectedItems[item.id] = true;
    }
  }

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  List<CartItemModel> get _selectedItemsList {
    return widget.order.items
        .where((item) => _selectedItems[item.id] == true)
        .toList();
  }

  double get _refundAmount {
    double total = 0;
    for (var item in _selectedItemsList) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> _confirmCancel() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn lý do hủy hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedItemsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chọn ít nhất một sản phẩm để hủy'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 1));
    final orderService = Provider.of<OrderService>(context, listen: false);
    orderService.updateOrderStatus(widget.order.id, OrderStatus.cancelled);
    setState(() => _isProcessing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hủy đơn hàng thành công'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _CancelAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrderIdentity(order: widget.order),
            const SizedBox(height: 32),
            _SelectItemsSection(
              items: widget.order.items,
              selectedItems: _selectedItems,
              onToggle: (id, val) => setState(() => _selectedItems[id] = val),
            ),
            const SizedBox(height: 32),
            _ReasonSection(
              selectedReason: _selectedReason,
              onChanged: (val) => setState(() => _selectedReason = val),
              otherController: _otherReasonController,
            ),
            const SizedBox(height: 32),
            _RefundNotice(amount: _refundAmount),
            const SizedBox(height: 32),
            _ActionButtons(
              isProcessing: _isProcessing,
              onConfirm: _confirmCancel,
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'CANCEL ORDER',
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: AppColors.neon,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _OrderIdentity extends StatelessWidget {
  final OrderModel order;
  const _OrderIdentity({required this.order});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.neon.withOpacity(0.2),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'VERIFICATION REQUIRED',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: AppColors.neon,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ORDER #${order.orderNumber}',
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 42,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              order.formattedDate,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Text('•', style: TextStyle(color: AppColors.border)),
            const SizedBox(width: 12),
            Text(
              '${order.totalQuantity} ITEMS TOTAL',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectItemsSection extends StatelessWidget {
  final List<CartItemModel> items;
  final Map<String, bool> selectedItems;
  final Function(String, bool) onToggle;
  const _SelectItemsSection({
    required this.items,
    required this.selectedItems,
    required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT ITEMS TO CANCEL',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => _CancelItemCard(
            item: item,
            isSelected: selectedItems[item.id] ?? false,
            onToggle: (val) => onToggle(item.id, val),
          ),
        ),
      ],
    );
  }
}

class _CancelItemCard extends StatelessWidget {
  final CartItemModel item;
  final bool isSelected;
  final Function(bool) onToggle;
  const _CancelItemCard({
    required this.item,
    required this.isSelected,
    required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.neon : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (v) => onToggle(v ?? false),
            activeColor: AppColors.neon,
            side: const BorderSide(color: AppColors.border),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imagePath,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surface,
                width: 56,
                height: 56,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatVnd(item.price * item.quantity),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonSection extends StatelessWidget {
  final String? selectedReason;
  final Function(String?) onChanged;
  final TextEditingController otherController;
  const _ReasonSection({
    required this.selectedReason,
    required this.onChanged,
    required this.otherController,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REASON FOR CANCELLATION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.neon.withOpacity(0.15),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.neon,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Please select a reason. This action cannot be undone.',
                        style: TextStyle(fontSize: 12, color: AppColors.neon),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _RadioTile(
                      label: 'Changed my mind',
                      value: 'changed_mind',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Found a better price',
                      value: 'better_price',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Incorrect shipping address',
                      value: 'wrong_address',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Shipping time too long',
                      value: 'shipping_time',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Other',
                      value: 'other',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    if (selectedReason == 'other')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextField(
                          controller: otherController,
                          maxLines: 3,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Tell us more (Optional)',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String label, value;
  final String? groupValue;
  final Function(String?) onChanged;
  const _RadioTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppColors.neon,
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.neon
                : AppColors.border,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: groupValue == value
                ? AppColors.neon
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _RefundNotice extends StatelessWidget {
  final double amount;
  const _RefundNotice({required this.amount});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: AppColors.neon, width: 3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.neon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'REFUND NOTICE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Refunds process in 3-5 business days. Shipping fees refundable for unshipped orders.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Refund amount: ${formatVnd(amount)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.neon,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback onConfirm;
  const _ActionButtons({required this.isProcessing, required this.onConfirm});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isProcessing ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neon,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'CONFIRM CANCELLATION',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text(
              'KEEP ORDER',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
