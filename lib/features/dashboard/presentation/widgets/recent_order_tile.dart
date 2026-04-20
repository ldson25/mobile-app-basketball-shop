import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RecentOrderTile extends StatelessWidget {
  const RecentOrderTile({
    super.key,
    required this.customer,
    required this.orderId,
    required this.status,
    required this.statusColor,
  });

  final String customer;
  final String orderId;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.neon.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.neon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  orderId,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
