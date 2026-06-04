import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../services/cart_service.dart';
import '../checkout/checkoutstepo.dart';

String formatVnd(double value) {
  final number = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < number.length; i++) {
    final fromEnd = number.length - i;
    buffer.write(number[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer}đ';
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _CartAppBar(),
      body: Consumer<CartService>(
        builder: (context, cartService, child) {
          final cartItems = cartService.cartItems;

          if (cartItems.isEmpty) {
            return const _EmptyCartView();
          }

          final selectedItems = cartService.selectedItems;
          final selectedSubtotal = cartService.selectedTotalAmount;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        for (final item in cartItems) {
                          cartService.toggleCheck(item.id);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            selectedItems.length == cartItems.length
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 20,
                            color: selectedItems.length == cartItems.length
                                ? AppColors.neon
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'CHỌN TẤT CẢ (${cartItems.length})',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (selectedItems.isNotEmpty)
                      GestureDetector(
                        onTap: () => _confirmRemoveSelected(context, cartService, selectedItems.length),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'XÓA',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        ...cartItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _CartItem(
                              id: item.id,
                              imagePath: item.imagePath,
                              title: item.title,
                              size: item.size,
                              price: item.price,
                              quantity: item.quantity,
                              isChecked: item.isChecked,
                              onQuantityChanged: cartService.updateQuantity,
                              onCheckChanged: cartService.toggleCheck,
                              onRemove: cartService.removeFromCart,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _OrderSummary(
                          selectedSubtotal: selectedSubtotal,
                          isFreeShipping: true,
                        ),
                        const SizedBox(height: 24),
                        _CheckoutButton(
                          isEnabled: selectedItems.isNotEmpty,
                          total: selectedSubtotal,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmRemoveSelected(
    BuildContext context,
    CartService cartService,
    int selectedCount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Xóa sản phẩm',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Xóa $selectedCount sản phẩm khỏi giỏ hàng?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HỦY'),
          ),
          TextButton(
            onPressed: () {
              cartService.removeCheckedItems();
              Navigator.pop(context);
            },
            child: const Text(
              'XÓA',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'GIỎ HÀNG ĐANG TRỐNG',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thêm sản phẩm để bắt đầu mua sắm',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neon,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text('MUA SẮM NGAY'),
          ),
        ],
      ),
    );
  }
}

class _CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CartAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(179),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back, color: AppColors.neon),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'GIỎ HÀNG',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
    required this.isChecked,
    required this.onQuantityChanged,
    required this.onCheckChanged,
    required this.onRemove,
  });

  final String id;
  final String imagePath;
  final String title;
  final String size;
  final double price;
  final int quantity;
  final bool isChecked;
  final void Function(String id, int quantity) onQuantityChanged;
  final void Function(String id) onCheckChanged;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    final totalPrice = price * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: AppColors.surface3,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onCheckChanged(id),
                      child: Icon(
                        isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 22,
                        color: isChecked ? AppColors.neon : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onRemove(id),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'TÙY CHỌN: $size',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: quantity > 1
                                ? () => onQuantityChanged(id, quantity - 1)
                                : null,
                            child: const SizedBox(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '$quantity',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onQuantityChanged(id, quantity + 1),
                            child: const SizedBox(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: AppColors.neon,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatVnd(totalPrice),
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.selectedSubtotal,
    required this.isFreeShipping,
  });

  final double selectedSubtotal;
  final bool isFreeShipping;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'SẢN PHẨM ĐÃ CHỌN', value: formatVnd(selectedSubtotal)),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'PHÍ GIAO HÀNG',
            value: isFreeShipping ? 'Tính ở bước sau' : formatVnd(30000),
            highlighted: isFreeShipping,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TẠM TÍNH',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
              Text(
                formatVnd(selectedSubtotal),
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: highlighted ? 12 : 18,
            fontWeight: FontWeight.w700,
            letterSpacing: highlighted ? 1.2 : 0,
            color: highlighted ? AppColors.neon : Colors.white,
          ),
        ),
      ],
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton({
    required this.isEnabled,
    required this.total,
  });

  final bool isEnabled;
  final double total;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutShippingScreen(
                    onMenuTap: () {},
                  ),
                ),
              );
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.neon : AppColors.border,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.neon.withAlpha(77),
                    blurRadius: 30,
                  ),
                ]
              : [],
        ),
        child: Text(
          'THANH TOÁN (${formatVnd(total)})',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: isEnabled ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
