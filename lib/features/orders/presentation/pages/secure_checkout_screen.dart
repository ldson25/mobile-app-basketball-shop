import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';

class SecureCheckoutScreen extends StatefulWidget {
  const SecureCheckoutScreen({super.key});

  @override
  State<SecureCheckoutScreen> createState() => _SecureCheckoutScreenState();
}

class _SecureCheckoutScreenState extends State<SecureCheckoutScreen> {
  int _shippingMethod = 1; // 0=Standard, 1=Express
  int _paymentMethod = 1; // 0=ApplePay, 1=Card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'KINETIC',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _PlaceOrderBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          16,
          AppSizes.pagePadding,
          32,
        ),
        children: [
          // ── Progress Steps ──
          const _CheckoutStepper(currentStep: 0),
          const SizedBox(height: 24),

          Text(
            'SECURE\nCHECKOUT',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 36,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),

          // ── Shipping Address ──
          _SectionHeader(label: 'Shipping Address', action: 'EDIT'),
          const SizedBox(height: 10),
          SectionCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Marcus Thompson',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '2135 Skyline Drive\nLos Angeles, CA 90012\nUnited States',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.neon,
                  size: 22,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Shipping Method ──
          _SectionHeader(label: 'Shipping Method'),
          const SizedBox(height: 10),
          _ShippingOption(
            selected: _shippingMethod == 0,
            title: 'Standard Delivery',
            subtitle: '3-5 Business Days',
            price: 'FREE',
            onTap: () => setState(() => _shippingMethod = 0),
          ),
          const SizedBox(height: 10),
          _ShippingOption(
            selected: _shippingMethod == 1,
            title: 'Express Motion',
            subtitle: 'Next Day Delivery',
            price: '\$15.00',
            onTap: () => setState(() => _shippingMethod = 1),
          ),
          const SizedBox(height: 24),

          // ── Payment Method ──
          _SectionHeader(label: 'Payment Method'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PaymentCard(
                  selected: _paymentMethod == 0,
                  label: 'Apple Pay',
                  icon: Icons.phone_iphone_rounded,
                  dark: false,
                  onTap: () => setState(() => _paymentMethod = 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentCard(
                  selected: _paymentMethod == 1,
                  label: 'Credit Card',
                  icon: Icons.credit_card_rounded,
                  dark: true,
                  onTap: () => setState(() => _paymentMethod = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SectionCard(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '**** **** **** 8842',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'EXPIRES 12/26',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Order Summary ──
          SectionCard(
            color: AppColors.surface3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORDER SUMMARY',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                // Item
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.sports_basketball_rounded,
                        color: AppColors.textMuted,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FLIGHT VELOCITY V1',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Size: 11 | Volt Green',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '\$180.00',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, thickness: 0.4),
                const SizedBox(height: 12),
                _SummaryRow(label: 'Subtotal', value: '\$180.00'),
                _SummaryRow(label: 'Shipping', value: '\$15.00'),
                _SummaryRow(label: 'Tax', value: '\$14.40'),
                const SizedBox(height: 12),
                const Divider(color: AppColors.border, thickness: 0.4),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 18),
                    ),
                    const Text(
                      '\$209.40',
                      style: TextStyle(
                        color: AppColors.neon,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // space for bottom bar
        ],
      ),
    );
  }
}

// ── Place Order Bottom Bar ──
class _PlaceOrderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(color: AppColors.background.withOpacity(0.9)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlowButton(
            label: 'PLACE ORDER',
            icon: Icons.arrow_forward_rounded,
            expanded: true,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          const Text(
            'SECURE ENCRYPTED TRANSACTION BY KINETIC PAY',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Checkout Stepper ──
class _CheckoutStepper extends StatelessWidget {
  final int currentStep;
  const _CheckoutStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = ['Shipping', 'Payment', 'Review'];
    return Row(
      children: List.generate(steps.length, (i) {
        final active = i == currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: active ? AppColors.neon : AppColors.surface3,
                  shape: BoxShape.circle,
                  border: active ? null : Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: active ? Colors.black : AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[i].toUpperCase(),
                style: TextStyle(
                  color: active ? AppColors.neon : AppColors.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? action;
  const _SectionHeader({required this.label, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              color: AppColors.neon,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
      ],
    );
  }
}

class _ShippingOption extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;

  const _ShippingOption({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SectionCard(
        color: selected ? AppColors.surface2 : AppColors.surface,
        border: selected
            ? Border.all(color: AppColors.neon.withOpacity(0.5))
            : Border.all(color: AppColors.border.withOpacity(0.1)),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.neon : AppColors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.neon,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? AppColors.neon : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                color: price == 'FREE' ? AppColors.neon : AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final bool selected;
  final String label;
  final IconData icon;
  final bool dark;
  final VoidCallback onTap;

  const _PaymentCard({
    required this.selected,
    required this.label,
    required this.icon,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: dark ? AppColors.surface3 : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: selected ? Border.all(color: AppColors.neon, width: 2) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: dark ? AppColors.neon : Colors.black, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: dark ? AppColors.textPrimary : Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
