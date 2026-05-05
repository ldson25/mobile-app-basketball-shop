import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final List<_CartItem> _items = [
    _CartItem(
      name: 'AIR-KINETIC MAX V4',
      variant: 'SIZE: US 10.5 | MIDNIGHT STEALTH',
      price: 185.00,
      qty: 1,
    ),
    _CartItem(
      name: 'ELITE MESH JERSEY',
      variant: 'SIZE: L | AERO-GRAPHITE',
      price: 65.00,
      qty: 2,
    ),
  ];

  double get _subtotal =>
      _items.fold(0, (sum, item) => sum + item.price * item.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: AppColors.neon),
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
            icon: const Icon(Icons.search, color: AppColors.neon),
          ),
        ],
      ),
      bottomNavigationBar: KineticBottomNav(currentIndex: 2, onTap: (i) {}),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          8,
          AppSizes.pagePadding,
          32,
        ),
        children: [
          // ── Hero heading ──
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w900,
                fontSize: 42,
                height: 0.95,
                fontStyle: FontStyle.italic,
              ),
              children: [
                TextSpan(
                  text: 'YOUR\n',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                TextSpan(
                  text: 'EQUIPMENT.',
                  style: TextStyle(color: AppColors.neon),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'SECURE YOUR HIGH-PERFORMANCE GEAR',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // ── Cart Items ──
          ..._items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CartItemCard(
                item: item,
                onDelete: () => setState(() => _items.removeAt(i)),
                onDecrement: () {
                  if (item.qty > 1) setState(() => item.qty--);
                },
                onIncrement: () => setState(() => item.qty++),
              ),
            );
          }),

          // ── Summary ──
          SectionCard(
            color: AppColors.surface2,
            border: const Border(
              top: BorderSide(color: AppColors.neon, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUMMARY',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _SummaryRow(
                  label: 'Subtotal',
                  value: '\$${_subtotal.toStringAsFixed(2)}',
                ),
                _SummaryRow(label: 'Shipping', value: '\$0.00'),
                const Divider(color: AppColors.border, thickness: 0.4),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 20),
                    ),
                    Text(
                      '\$${_subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.neon,
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GlowButton(
                  label: 'PROCEED TO CHECKOUT',
                  expanded: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem {
  final String name;
  final String variant;
  final double price;
  int qty;

  _CartItem({
    required this.name,
    required this.variant,
    required this.price,
    required this.qty,
  });
}

class _CartItemCard extends StatelessWidget {
  final _CartItem item;
  final VoidCallback onDelete;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CartItemCard({
    required this.item,
    required this.onDelete,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: 110,
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sports_basketball_rounded,
              color: AppColors.textMuted,
              size: 40,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.variant,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Qty stepper
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface3,
                        borderRadius: BorderRadius.circular(
                          AppSizes.buttonRadius,
                        ),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          _QtyButton(icon: Icons.remove, onTap: onDecrement),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.qty}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: onIncrement,
                            active: true,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(item.price * item.qty).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.neon,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
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

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(
          icon,
          size: 16,
          color: active ? AppColors.neon : AppColors.textSecondary,
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
      padding: const EdgeInsets.symmetric(vertical: 5),
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
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
