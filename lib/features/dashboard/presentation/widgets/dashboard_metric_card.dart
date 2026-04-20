import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/section_card.dart';

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
    this.compact = false,
  });

  final String label;
  final String value;
  final String change;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Stack(
        children: [
          Positioned(
            right: -4,
            bottom: -4,
            child: Icon(
              icon,
              size: compact ? 52 : 72,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: compact ? 36 : 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  height: 0.95,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.neon,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    change,
                    style: const TextStyle(
                      color: AppColors.neon,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
