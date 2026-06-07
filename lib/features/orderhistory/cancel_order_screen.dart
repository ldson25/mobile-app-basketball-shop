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

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key, required this.order});

  final OrderModel order;

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final TextEditingController _otherReasonController = TextEditingController();
  final Map<String, bool> _selectedItems = {};
  String? _selectedReason;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    for (final item in widget.order.items) {
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
    return _selectedItemsList.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  Future<void> _confirmCancel() async {
    if (_selectedReason == null) {
      _showMessage('Vui lòng chọn lý do hủy hàng');
      return;
    }
    if (_selectedItemsList.isEmpty) {
      _showMessage('Chọn ít nhất một sản phẩm để hủy');
      return;
    }

    setState(() => _isProcessing = true);
    final reason = _selectedReason == 'other'
        ? _otherReasonController.text.trim()
        : _selectedReason!;
    final orderService = context.read<OrderService>();
    await orderService.createReturnRequest(
      orderId: widget.order.id,
      itemIds: _selectedItemsList.map((item) => item.id).toList(),
      reason: reason.isEmpty ? 'other' : reason,
      condition: 'not_required',
      refundMethod: 'cod_refund',
      refundAmount: _refundAmount,
      requestType: 'cancel',
      note: 'Khách yêu cầu hủy đơn',
    );
    await orderService.updateOrderStatus(
      widget.order.id,
      OrderStatus.cancelled,
      note: 'Khách yêu cầu hủy đơn',
    );
    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hủy đơn hàng thành công'),
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
      appBar: const _CancelAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrderIdentity(order: widget.order),
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
              otherController: _otherReasonController,
            ),
            const SizedBox(height: 28),
            _RefundNotice(amount: _refundAmount),
            const SizedBox(height: 28),
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
  const _CancelAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'HỦY ĐƠN HÀNG',
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

class _OrderIdentity extends StatelessWidget {
  const _OrderIdentity({required this.order});

  final OrderModel order;

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
          child: Text(
            'CẦN XÁC NHẬN',
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
          'ĐƠN ${order.orderNumber}',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 34,
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
              order.formattedDate,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            Text(
              '${order.totalQuantity} sản phẩm',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
        const _SectionLabel('CHỌN SẢN PHẨM MUỐN HỦY'),
        const SizedBox(height: 14),
        ...items.map(
          (item) => _CancelItemCard(
            item: item,
            isSelected: selectedItems[item.id] ?? false,
            onToggle: (value) => onToggle(item.id, value),
          ),
        ),
      ],
    );
  }
}

class _CancelItemCard extends StatelessWidget {
  const _CancelItemCard({
    required this.item,
    required this.isSelected,
    required this.onToggle,
  });

  final CartItemModel item;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

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
            onChanged: (value) => onToggle(value ?? false),
            activeColor: AppColors.neon,
            side: BorderSide(color: AppColors.border),
          ),
          const SizedBox(width: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _CartItemImage(path: item.imagePath, width: 56, height: 56),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size} / SL: ${item.quantity}',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatVnd(item.price * item.quantity),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonSection extends StatelessWidget {
  const _ReasonSection({
    required this.selectedReason,
    required this.onChanged,
    required this.otherController,
  });

  final String? selectedReason;
  final ValueChanged<String?> onChanged;
  final TextEditingController otherController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('LÝ DO HỦY ĐƠN'),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.neon, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Vui lòng chọn lý do. Sau khi hủy, đơn không thể cập nhật lại.',
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
                      label: 'Đổi ý không muốn mua',
                      value: 'changed_mind',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Tìm được giá tốt hơn',
                      value: 'better_price',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Sai địa chỉ giao hàng',
                      value: 'wrong_address',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Thời gian giao quá lâu',
                      value: 'shipping_time',
                      groupValue: selectedReason,
                      onChanged: onChanged,
                    ),
                    _RadioTile(
                      label: 'Lý do khác',
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
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Nhập lý do hủy đơn',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
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
  const _RadioTile({
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
        style: TextStyle(
          fontSize: 14,
          color: groupValue == value ? AppColors.neon : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RefundNotice extends StatelessWidget {
  const _RefundNotice({required this.amount});

  final double amount;

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
          Icon(Icons.info_outline, color: AppColors.neon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THÔNG TIN HOÀN TIỀN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nếu đơn chưa giao, hệ thống sẽ loại đơn này khỏi doanh thu báo cáo.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Số tiền dự kiến: ${formatVnd(amount)}',
                  style: TextStyle(
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
  const _ActionButtons({
    required this.isProcessing,
    required this.onConfirm,
  });

  final bool isProcessing;
  final VoidCallback onConfirm;

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
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'XÁC NHẬN HỦY ĐƠN',
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
              side: BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text(
              'GIỮ LẠI ĐƠN',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
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
      child: Icon(
        Icons.image_not_supported,
        color: AppColors.textSecondary,
      ),
    );
  }
}
