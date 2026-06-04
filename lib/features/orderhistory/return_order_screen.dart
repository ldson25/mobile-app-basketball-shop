import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/order_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../services/order_service.dart';

// Hàm format tiền VND
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

class ReturnOrderScreen extends StatefulWidget {
  final OrderModel order;
  const ReturnOrderScreen({super.key, required this.order});

  @override
  State<ReturnOrderScreen> createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  String? _selectedReason;
  String? _selectedMethod;
  bool _conditionConfirmed = false;
  Map<String, bool> _selectedItems = {}; // key = CartItemModel.id
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Mặc định chọn tất cả items
    for (var item in widget.order.items) {
      _selectedItems[item.id] = true;
    }
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

  Future<void> _submitReturn() async {
    if (_selectedItemsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chọn ít nhất một sản phẩm để trả hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn lý do trả hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_conditionConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn cần xác nhận sản phẩm còn nguyên tem mác'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn phương thức trả hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    // Gọi service trả hàng (tạm thời giả lập)
    await Future.delayed(const Duration(seconds: 1));
    final orderService = Provider.of<OrderService>(context, listen: false);
    // Giả sử cập nhật trạng thái đơn hàng thành returned (bạn có thể thêm enum nếu cần)
    orderService.updateOrderStatus(
      widget.order.id,
      OrderStatus.cancelled,
    ); // tạm thời
    setState(() => _isProcessing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yêu cầu trả hàng đã được gửi'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // đóng màn hình return
      Navigator.pop(context); // quay về danh sách đơn hàng
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _ReturnAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Context Header
            _OrderHeader(order: widget.order),
            const SizedBox(height: 32),
            // 1. SELECT ITEMS
            _SelectItemsSection(
              items: widget.order.items,
              selectedItems: _selectedItems,
              onToggle: (id, val) => setState(() => _selectedItems[id] = val),
            ),
            const SizedBox(height: 32),
            // 2. REASON FOR RETURN
            _ReasonSection(
              selectedReason: _selectedReason,
              onChanged: (val) => setState(() => _selectedReason = val),
            ),
            const SizedBox(height: 32),
            // 3. CONDITION
            _ConditionSection(
              value: _conditionConfirmed,
              onChanged: (val) => setState(() => _conditionConfirmed = val),
            ),
            const SizedBox(height: 32),
            // 4. RETURN METHOD
            _MethodSection(
              selectedMethod: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            const SizedBox(height: 48),
            // Footer with refund total and submit button
            _FooterSection(
              refundAmount: _refundAmount,
              isProcessing: _isProcessing,
              onSubmit: _submitReturn,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnAppBar extends StatelessWidget implements PreferredSizeWidget {
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
        'RETURN ITEMS',
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

class _OrderHeader extends StatelessWidget {
  final OrderModel order;
  const _OrderHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDER SUMMARY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppColors.neon,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ORDER #${order.orderNumber}',
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.neon,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Status: ${order.status.label}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              'Delivered on ${order.formattedDate}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
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
        Row(
          children: [
            Expanded(
              child: Text(
                '1. SELECT ITEMS',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Space Grotesk',
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${items.length} Items available',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selectedItems[item.id] ?? false;
            return _ReturnItemCard(
              item: item,
              isSelected: isSelected,
              onToggle: (val) => onToggle(item.id, val),
            );
          },
        ),
      ],
    );
  }
}

class _ReturnItemCard extends StatelessWidget {
  final CartItemModel item;
  final bool isSelected;
  final Function(bool) onToggle;
  const _ReturnItemCard({
    required this.item,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isSelected),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neon : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    item.imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (val) => onToggle(val ?? false),
                    activeColor: AppColors.neon,
                    checkColor: AppColors.background,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SIZE: ${item.size}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatVnd(item.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.neon,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonSection extends StatelessWidget {
  final String? selectedReason;
  final ValueChanged<String?> onChanged;
  const _ReasonSection({required this.selectedReason, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. REASON FOR RETURN',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Space Grotesk',
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _ReasonRadio(
                  label: 'Wrong size',
                  value: 'wrong_size',
                  groupValue: selectedReason,
                  onChanged: onChanged,
                ),
                _ReasonRadio(
                  label: 'Defective/Damaged',
                  value: 'defective',
                  groupValue: selectedReason,
                  onChanged: onChanged,
                ),
                _ReasonRadio(
                  label: 'Not as described',
                  value: 'not_as_described',
                  groupValue: selectedReason,
                  onChanged: onChanged,
                ),
                _ReasonRadio(
                  label: 'Changed my mind',
                  value: 'changed_mind',
                  groupValue: selectedReason,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReasonRadio extends StatelessWidget {
  final String label, value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  const _ReasonRadio({
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
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}

class _ConditionSection extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ConditionSection({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. CONDITION',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Space Grotesk',
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (val) => onChanged(val ?? false),
                activeColor: AppColors.neon,
                checkColor: AppColors.background,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Condition Guarantee',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'I confirm the item is in its original packaging, unworn, and all tags are still attached.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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

class _MethodSection extends StatelessWidget {
  final String? selectedMethod;
  final ValueChanged<String?> onChanged;
  const _MethodSection({required this.selectedMethod, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. RETURN METHOD',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Space Grotesk',
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MethodCard(
                icon: Icons.location_on,
                label: 'DROP-OFF AT LOCATION',
                value: 'drop_off',
                selectedMethod: selectedMethod,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MethodCard(
                icon: Icons.print,
                label: 'PRINT SHIPPING LABEL',
                value: 'print_label',
                selectedMethod: selectedMethod,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? selectedMethod;
  final ValueChanged<String?> onChanged;

  const _MethodCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neon : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.neon : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.neon : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final double refundAmount;
  final bool isProcessing;
  final VoidCallback onSubmit;
  const _FooterSection({
    required this.refundAmount,
    required this.isProcessing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESTIMATED REFUND',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatVnd(refundAmount),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Space Grotesk',
                        fontStyle: FontStyle.italic,
                        color: AppColors.neon,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isProcessing ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : const Text(
                        'SUBMIT RETURN REQUEST',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Returns are processed within 3-5 business days upon receipt.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
