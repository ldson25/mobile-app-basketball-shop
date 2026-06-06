import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/order_model.dart';
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

class ReturnOrderScreen extends StatefulWidget {
  const ReturnOrderScreen({super.key, required this.order});

  final OrderModel order;

  @override
  State<ReturnOrderScreen> createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  final Map<String, bool> _selectedItems = {};
  String? _selectedReason;
  String? _selectedMethod;
  bool _conditionConfirmed = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    for (final item in widget.order.items) {
      _selectedItems[item.id] = true;
    }
  }

  List<CartItemModel> get _selectedItemsList {
    return widget.order.items
        .where((item) => _selectedItems[item.id] == true)
        .toList();
  }

  double get _refundAmount {
    return _selectedItemsList.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  Future<void> _submitReturn() async {
    if (_selectedItemsList.isEmpty) {
      _showMessage('Chọn ít nhất một sản phẩm để trả hàng');
      return;
    }
    if (_selectedReason == null) {
      _showMessage('Vui lòng chọn lý do trả hàng');
      return;
    }
    if (!_conditionConfirmed) {
      _showMessage('Bạn cần xác nhận sản phẩm còn nguyên tem mác');
      return;
    }
    if (_selectedMethod == null) {
      _showMessage('Vui lòng chọn phương thức trả hàng');
      return;
    }

    setState(() => _isProcessing = true);
    final orderService = context.read<OrderService>();
    await orderService.createReturnRequest(
      orderId: widget.order.id,
      itemIds: _selectedItemsList.map((item) => item.id).toList(),
      reason: _selectedReason!,
      condition: 'confirmed_original_condition',
      refundMethod: _selectedMethod!,
      refundAmount: _refundAmount,
      requestType: 'return',
      note: 'Khách yêu cầu trả hàng',
    );
    await orderService.updateOrderStatus(
      widget.order.id,
      OrderStatus.returned,
      note: 'Khách yêu cầu trả hàng',
    );
    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yêu cầu trả hàng đã được gửi'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _ReturnAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrderHeader(order: widget.order),
            const SizedBox(height: 28),
            _SelectItemsSection(
              items: widget.order.items,
              selectedItems: _selectedItems,
              onToggle: (id, value) => setState(() => _selectedItems[id] = value),
            ),
            const SizedBox(height: 28),
            _ReasonSection(
              selectedReason: _selectedReason,
              onChanged: (value) => setState(() => _selectedReason = value),
            ),
            const SizedBox(height: 28),
            _ConditionSection(
              value: _conditionConfirmed,
              onChanged: (value) => setState(() => _conditionConfirmed = value),
            ),
            const SizedBox(height: 28),
            _MethodSection(
              selectedMethod: _selectedMethod,
              onChanged: (value) => setState(() => _selectedMethod = value),
            ),
            const SizedBox(height: 36),
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
  const _ReturnAppBar();

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
        'TRẢ HÀNG',
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 18,
          fontWeight: FontWeight.w900,
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
  const _OrderHeader({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TÓM TẮT ĐƠN HÀNG',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppColors.neon,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ĐƠN ${order.orderNumber}',
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            Text(
              'Trạng thái: ${order.status.label}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Ngày giao: ${order.formattedDate}',
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
  const _SelectItemsSection({
    required this.items,
    required this.selectedItems,
    required this.onToggle,
  });

  final List<CartItemModel> items;
  final Map<String, bool> selectedItems;
  final void Function(String id, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: '1. CHỌN SẢN PHẨM',
          trailing: '${items.length} sản phẩm',
        ),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReturnItemCard(
              item: item,
              isSelected: selectedItems[item.id] ?? false,
              onToggle: (value) => onToggle(item.id, value),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReturnItemCard extends StatelessWidget {
  const _ReturnItemCard({
    required this.item,
    required this.isSelected,
    required this.onToggle,
  });

  final CartItemModel item;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isSelected),
      child: Container(
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
              onChanged: (value) => onToggle(value ?? false),
              activeColor: AppColors.neon,
              checkColor: AppColors.background,
              side: const BorderSide(color: AppColors.border),
            ),
            const SizedBox(width: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _CartItemImage(path: item.imagePath, width: 64, height: 64),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${item.size} / SL: ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatVnd(item.price * item.quantity),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: AppColors.neon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonSection extends StatelessWidget {
  const _ReasonSection({
    required this.selectedReason,
    required this.onChanged,
  });

  final String? selectedReason;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _OptionGroup(
      title: '2. LÝ DO TRẢ HÀNG',
      children: [
        _ReasonRadio(
          label: 'Sai kích cỡ',
          value: 'wrong_size',
          groupValue: selectedReason,
          onChanged: onChanged,
        ),
        _ReasonRadio(
          label: 'Sản phẩm lỗi / hư hỏng',
          value: 'defective',
          groupValue: selectedReason,
          onChanged: onChanged,
        ),
        _ReasonRadio(
          label: 'Không đúng mô tả',
          value: 'not_as_described',
          groupValue: selectedReason,
          onChanged: onChanged,
        ),
        _ReasonRadio(
          label: 'Đổi ý không muốn mua',
          value: 'changed_mind',
          groupValue: selectedReason,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ReasonRadio extends StatelessWidget {
  const _ReasonRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColors.neon,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      ),
    );
  }
}

class _ConditionSection extends StatelessWidget {
  const _ConditionSection({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _OptionGroup(
      title: '3. TÌNH TRẠNG SẢN PHẨM',
      children: [
        CheckboxListTile(
          value: value,
          onChanged: (checked) => onChanged(checked ?? false),
          activeColor: AppColors.neon,
          checkColor: AppColors.background,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Tôi xác nhận sản phẩm còn bao bì, chưa sử dụng và còn đầy đủ tem mác.',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _MethodSection extends StatelessWidget {
  const _MethodSection({
    required this.selectedMethod,
    required this.onChanged,
  });

  final String? selectedMethod;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: '4. PHƯƠNG THỨC TRẢ HÀNG'),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MethodCard(
                icon: Icons.location_on,
                label: 'Gửi tại điểm nhận',
                value: 'drop_off',
                selectedMethod: selectedMethod,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MethodCard(
                icon: Icons.print,
                label: 'In nhãn giao hàng',
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
  const _MethodCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.selectedMethod,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? selectedMethod;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        constraints: const BoxConstraints(minHeight: 122),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neon : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? AppColors.neon : AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({
    required this.refundAmount,
    required this.isProcessing,
    required this.onSubmit,
  });

  final double refundAmount;
  final bool isProcessing;
  final VoidCallback onSubmit;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SỐ TIỀN DỰ KIẾN HOÀN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isProcessing ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neon,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : const Text(
                          'GỬI YÊU CẦU TRẢ HÀNG',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Yêu cầu trả hàng sẽ được xử lý trong 3-5 ngày làm việc sau khi nhận hàng.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: title),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Space Grotesk',
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

class _CartItemImage extends StatelessWidget {
  const _CartItemImage({
    required this.path,
    required this.width,
    required this.height,
  });

  final String path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _ImageFallback(width: width, height: height),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _ImageFallback(width: width, height: height),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      child: const Icon(
        Icons.image_not_supported,
        color: AppColors.textSecondary,
      ),
    );
  }
}
