import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/section_card.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    super.key,
    required this.orderId,
    required this.customer,
    required this.itemCount,
    required this.amount,
    required this.date,
    required this.status,
    required this.statusColor,
    this.dimmed = false,
  });

  final String orderId;
  final String customer;
  final String itemCount;
  final String amount;
  final String date;
  final String status;
  final Color statusColor;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final textColor = dimmed ? AppColors.textMuted : AppColors.textPrimary;

    return Opacity(
      opacity: dimmed ? 0.55 : 1,
      child: SectionCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.surfaceHighest,
                    AppColors.surface,
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          orderId,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: statusColor.withOpacity(0.22),
                          ),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$customer   /   $itemCount',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    amount,
                    style: TextStyle(
                      color: dimmed ? AppColors.textMuted : AppColors.neon,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ActionButton(icon: Icons.remove_red_eye_outlined),
                      SizedBox(width: 12),
                      _ActionButton(icon: Icons.edit_outlined),
                      SizedBox(width: 12),
                      _ActionButton(icon: Icons.delete_outline_rounded),
                    ],
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.surfaceHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 20),
    );
  }
}
