import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SimpleRevenueChart extends StatelessWidget {
  const SimpleRevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL'];
    const shoes = [0.40, 0.65, 0.55, 0.85, 0.75, 0.95, 0.80];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(months.length, (index) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 160 * shoes[index],
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.neon,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                months[index],
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
