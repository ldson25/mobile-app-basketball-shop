import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../services/checkout_service.dart';
import 'checkoutstepth.dart';
import '../cart/mycart.dart';

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

double _calculateVoucherDiscount(String code, double subtotal) {
  switch (code) {
    case 'MEMBER10':
      return subtotal * 0.1;
    case 'VIP20':
      return subtotal >= 5000000 ? subtotal * 0.2 : 0;
    case 'KINETIC50':
      return subtotal >= 1000000 ? 50000 : 0;
    default:
      return 0;
  }
}

class CheckoutPaymentScreen extends StatefulWidget {
  final VoidCallback onMenuTap;
  final Map<String, String>? shippingData;

  const CheckoutPaymentScreen({
    super.key,
    required this.onMenuTap,
    this.shippingData,
  });

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String selectedPaymentMethod = 'cash';
  String? _appliedVoucherCode;
  double _voucherDiscount = 0;
  bool _isProcessing = false;

  final TextEditingController voucherController = TextEditingController();

  // Credit card controllers
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _PaymentAppBar(onMenuTap: widget.onMenuTap),
      body: Consumer2<CartService, OrderService>(
        builder: (context, cartService, orderService, child) {
          final selectedItems = cartService.selectedItems;
          final subtotal = cartService.selectedTotalAmount;
          final shippingCost =
              double.tryParse(widget.shippingData?['shippingCost'] ?? '') ?? 0.0;
          final discount = _voucherDiscount.clamp(0, subtotal).toDouble();
          final total = subtotal + shippingCost - discount;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const _ProgressIndicator(currentStep: 2),
                  const SizedBox(height: 32),
                  const _HeaderSection(),
                  const SizedBox(height: 32),
                  _PaymentMethodSection(
                    selectedMethod: selectedPaymentMethod,
                    onMethodChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  if (selectedPaymentMethod == 'credit_card')
                    _CreditCardForm(
                      cardNumberController: cardNumberController,
                      cardHolderController: cardHolderController,
                      expiryController: expiryController,
                      cvvController: cvvController,
                    ),
                  if (selectedPaymentMethod == 'cash')
                    const _CashOnDeliveryInfo(),
                  if (selectedPaymentMethod == 'bank_transfer')
                    const _BankTransferInfo(),
                  if (selectedPaymentMethod == 'e_wallet')
                    const _EWalletInfo(),
                  const SizedBox(height: 32),
                  _VoucherSection(
                    controller: voucherController,
                    appliedCode: _appliedVoucherCode,
                    discount: discount,
                    onApply: () {
                      final code = voucherController.text.trim().toUpperCase();
                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nhập mã voucher')),
                        );
                        return;
                      }

                      final discountValue = _calculateVoucherDiscount(
                        code,
                        subtotal,
                      );

                      if (discountValue <= 0) {
                        setState(() {
                          _appliedVoucherCode = null;
                          _voucherDiscount = 0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voucher không hợp lệ hoặc chưa đủ điều kiện'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _appliedVoucherCode = code;
                        _voucherDiscount = discountValue;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        _appliedVoucherCode = null;
                        _voucherDiscount = 0;
                        voucherController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _OrderSummary(
                    subtotal: subtotal,
                    shippingCost: shippingCost,
                    discount: discount,
                    total: total,
                    shippingLabel: widget.shippingData?['shippingLabel'],
                  ),
                  const SizedBox(height: 24),
                  _PlaceOrderButton(
                    selectedMethod: selectedPaymentMethod,
                    selectedItems: selectedItems,
                    subtotal: subtotal,
                    shippingCost: shippingCost,
                    discount: discount,
                    voucherCode: _appliedVoucherCode,
                    total: total,
                    shippingData: widget.shippingData,
                    isProcessing: _isProcessing,
                    onProcessingChanged: (value) {
                      setState(() {
                        _isProcessing = value;
                      });
                    },
                    onMenuTap: widget.onMenuTap,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    voucherController.dispose();
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}

class _PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const _PaymentAppBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(230),
        border: Border(
          bottom: BorderSide(color: AppColors.border.withAlpha(51)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 40),
              const Expanded(
                child: Center(
                  child: Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -0.5,
                      color: AppColors.neon,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;

  const _ProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: Container(height: 2, color: AppColors.border),
          ),
          Positioned(
            top: 28,
            left: 0,
            right: MediaQuery.of(context).size.width * (1 - (currentStep / 3)),
            child: Container(height: 2, color: AppColors.neon),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _ProgressStep(
                isActive: true,
                icon: Icons.local_shipping,
                iconColor: AppColors.surface,
                backgroundColor: AppColors.neon,
              ),
              const _ProgressStep(
                isActive: true,
                icon: Icons.payment,
                iconColor: AppColors.surface,
                backgroundColor: AppColors.neon,
              ),
              const _ProgressStep(
                isActive: false,
                icon: Icons.check_circle,
                iconColor: AppColors.textSecondary,
                backgroundColor: AppColors.surface2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _ProgressStep({
    required this.isActive,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: isActive ? null : Border.all(color: AppColors.border),
        boxShadow: isActive
            ? [BoxShadow(color: AppColors.neon.withAlpha(77), blurRadius: 15)]
            : null,
      ),
      child: Icon(icon, size: 22, color: iconColor),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thanh toán',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 48,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Chọn phương thức thanh toán phù hợp tại Việt Nam.',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CashOnDeliveryInfo extends StatelessWidget {
  const _CashOnDeliveryInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neon.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.neon.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline, color: AppColors.neon, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thanh toán khi nhận hàng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kiểm tra hàng và thanh toán trực tiếp cho shipper.',
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
    );
  }

}

class _BankTransferInfo extends StatelessWidget {
  const _BankTransferInfo();

  @override
  Widget build(BuildContext context) {
    return const _PaymentNotice(
      icon: Icons.account_balance_rounded,
      title: 'Chuyển khoản ngân hàng',
      message: 'Thông tin tài khoản sẽ được gửi sau khi đơn hàng được tạo.',
    );
  }
}

class _EWalletInfo extends StatelessWidget {
  const _EWalletInfo();

  @override
  Widget build(BuildContext context) {
    return const _PaymentNotice(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Ví điện tử',
      message: 'Hỗ trợ MoMo, ZaloPay và VNPay trong giai đoạn tích hợp sau.',
    );
  }
}

class _PaymentNotice extends StatelessWidget {
  const _PaymentNotice({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neon.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.neon.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.neon, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
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
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const _PaymentMethodSection({
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentOption(
          value: 'cash',
          icon: Icons.money,
          title: 'Thanh toán khi nhận hàng',
          subtitle: 'Nhận hàng rồi thanh toán cho shipper',
          isSelected: selectedMethod == 'cash',
          onTap: () => onMethodChanged('cash'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'bank_transfer',
          icon: Icons.account_balance_rounded,
          title: 'Chuyển khoản ngân hàng',
          subtitle: 'Phù hợp với đơn giá trị cao',
          isSelected: selectedMethod == 'bank_transfer',
          onTap: () => onMethodChanged('bank_transfer'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'e_wallet',
          icon: Icons.account_balance_wallet_rounded,
          title: 'Ví điện tử',
          subtitle: 'MoMo, ZaloPay, VNPay',
          isSelected: selectedMethod == 'e_wallet',
          onTap: () => onMethodChanged('e_wallet'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'credit_card',
          icon: Icons.credit_card,
          title: 'Thẻ tín dụng / ghi nợ',
          subtitle: 'Visa, Mastercard',
          isSelected: selectedMethod == 'credit_card',
          onTap: () => onMethodChanged('credit_card'),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.neon : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: isSelected ? value : null,
              onChanged: (_) => onTap(),
              activeColor: AppColors.neon,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.neon;
                }
                return AppColors.border;
              }),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.neon, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
      ),
    );
  }
}

class _CreditCardForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController cardHolderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  const _CreditCardForm({
    required this.cardNumberController,
    required this.cardHolderController,
    required this.expiryController,
    required this.cvvController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InputField(
          label: 'SỐ THẺ',
          hint: '1234 5678 9012 3456',
          controller: cardNumberController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _InputField(
          label: 'TÊN CHỦ THẺ',
          hint: 'JOHN DOE',
          controller: cardHolderController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'NGÀY HẾT HẠN',
                hint: 'MM/YY',
                controller: expiryController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InputField(
                label: 'CVV',
                hint: '123',
                controller: cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VoucherSection extends StatelessWidget {
  const _VoucherSection({
    required this.controller,
    required this.appliedCode,
    required this.discount,
    required this.onApply,
    required this.onRemove,
  });

  final TextEditingController controller;
  final String? appliedCode;
  final double discount;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasVoucher = appliedCode != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VOUCHER',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !hasVoucher,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'MEMBER10, VIP20, KINETIC50',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.neon),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: hasVoucher ? onRemove : onApply,
                icon: Icon(
                  hasVoucher ? Icons.close_rounded : Icons.check_rounded,
                  color: hasVoucher ? AppColors.error : AppColors.background,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: hasVoucher ? AppColors.surfaceHighest : AppColors.neon,
                  fixedSize: const Size(52, 52),
                ),
              ),
            ],
          ),
          if (hasVoucher) ...[
            const SizedBox(height: 10),
            Text(
              '$appliedCode da ap dung: -${formatVnd(discount)}',
              style: const TextStyle(
                color: AppColors.neon,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.border),
            filled: true,
            fillColor: AppColors.surface2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neon, width: 1),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;
  final String? shippingLabel;

  const _OrderSummary({
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
    this.shippingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withAlpha(51)),
      ),
      child: Column(
        children: [
          const Text(
            'TÓM TẮT ĐƠN HÀNG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Tạm tính',
            value: formatVnd(subtotal),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: shippingLabel ?? 'Phí giao hàng',
            value: shippingCost > 0 ? formatVnd(shippingCost) : 'Miễn phí',
          ),
          if (discount > 0) ...[
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Voucher',
              value: '-${formatVnd(discount)}',
            ),
          ],
          const Divider(color: AppColors.border, height: 24),
          _SummaryRow(
            label: 'TỔNG CỘNG',
            value: formatVnd(total),
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

class _PlaceOrderButton extends StatelessWidget {
  final String selectedMethod;
  final List<dynamic> selectedItems;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final String? voucherCode;
  final double total;
  final Map<String, String>? shippingData;
  final bool isProcessing;
  final ValueChanged<bool> onProcessingChanged;
  final VoidCallback onMenuTap;

  const _PlaceOrderButton({
    required this.selectedMethod,
    required this.selectedItems,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.voucherCode,
    required this.total,
    required this.shippingData,
    required this.isProcessing,
    required this.onProcessingChanged,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isProcessing
            ? null
            : () async {
                // Validate credit card if needed
                if (selectedMethod == 'credit_card') {
                  // Add validation logic here
                }

                // Show loading
                onProcessingChanged(true);

                // Process checkout
                final checkoutService = CheckoutService();
                final shippingAddress = [
                  shippingData?['street'],
                      shippingData?['ward'],
                      shippingData?['district'],
                      shippingData?['city'],
                      shippingData?['country'],
                ].where((part) => part != null && part.isNotEmpty).join(', ');
                final success = await checkoutService.processCheckout(
                  shippingAddress: shippingAddress.isEmpty
                      ? 'No address provided'
                      : shippingAddress,
                  phoneNumber: shippingData?['phone'] ?? 'No phone provided',
                  shippingCost: shippingCost,
                  discount: discount,
                  paymentMethod: selectedMethod,
                  customerName: shippingData?['fullName'] ?? '',
                  shippingMethod: shippingData?['shippingMethod'] ?? 'free',
                  voucherCode: voucherCode,
                );

                onProcessingChanged(false);

                if (success) {
                  // Navigate to success screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutSuccessScreen(
                        onMenuTap: onMenuTap,
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đặt hàng thất bại. Vui lòng thử lại.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neon,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
          disabledBackgroundColor: AppColors.border,
        ),
        child: isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.background,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'ĐẶT HÀNG',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                ),
              ),
      ),
    );
  }
}
