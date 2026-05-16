import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/cart_service.dart';
import '../../../services/order_service.dart';
import '../../../services/checkout_service.dart';
import 'checkoutstepth.dart';
import '../cart/mycart.dart';

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
  String selectedPaymentMethod = 'credit_card';
  bool _isProcessing = false;

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
          final shippingCost = 10.0; // Giả định, có thể lấy từ shippingData
          final total = subtotal + shippingCost;

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
                  const SizedBox(height: 32),
                  _OrderSummary(
                    subtotal: subtotal,
                    shippingCost: shippingCost,
                    total: total,
                  ),
                  const SizedBox(height: 24),
                  _PlaceOrderButton(
                    selectedMethod: selectedPaymentMethod,
                    selectedItems: selectedItems,
                    subtotal: subtotal,
                    shippingCost: shippingCost,
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
                    'Payment',
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
          'Payment',
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
          'Select your preferred payment method',
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
                  'Cash on Delivery',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pay with cash directly to the delivery driver',
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
          value: 'credit_card',
          icon: Icons.credit_card,
          title: 'Credit / Debit Card',
          subtitle: 'Pay with Visa, Mastercard, Amex',
          isSelected: selectedMethod == 'credit_card',
          onTap: () => onMethodChanged('credit_card'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'paypal',
          icon: Icons.payments,
          title: 'PayPal',
          subtitle: 'Fast checkout with PayPal',
          isSelected: selectedMethod == 'paypal',
          onTap: () => onMethodChanged('paypal'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'digital_wallet',
          icon: Icons.wallet,
          title: 'Digital Wallet',
          subtitle: 'Apple Pay, Google Pay',
          isSelected: selectedMethod == 'digital_wallet',
          onTap: () => onMethodChanged('digital_wallet'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'cash',
          icon: Icons.money,
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive the order',
          isSelected: selectedMethod == 'cash',
          onTap: () => onMethodChanged('cash'),
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
          label: 'CARD NUMBER',
          hint: '1234 5678 9012 3456',
          controller: cardNumberController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _InputField(
          label: 'CARDHOLDER NAME',
          hint: 'JOHN DOE',
          controller: cardHolderController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'EXPIRY DATE',
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
  final double total;

  const _OrderSummary({
    required this.subtotal,
    required this.shippingCost,
    required this.total,
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
            'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Shipping',
            value: shippingCost > 0 ? '\$${shippingCost.toStringAsFixed(2)}' : 'FREE',
          ),
          const Divider(color: AppColors.border, height: 24),
          _SummaryRow(
            label: 'TOTAL',
            value: '\$${total.toStringAsFixed(2)}',
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
                final success = await checkoutService.processCheckout(
                  shippingAddress: shippingData?['address'] ?? 'No address provided',
                  phoneNumber: shippingData?['phone'] ?? 'No phone provided',
                  shippingCost: shippingCost,
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
                      content: Text('Failed to place order. Please try again.'),
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
                'PLACE ORDER',
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