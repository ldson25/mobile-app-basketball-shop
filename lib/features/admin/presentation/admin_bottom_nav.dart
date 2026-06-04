import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const items = <_AdminNavItem>[
    _AdminNavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _AdminNavItem(icon: Icons.inventory_2_rounded, label: 'Sản phẩm'),
    _AdminNavItem(icon: Icons.receipt_long_rounded, label: 'Đơn hàng'),
    _AdminNavItem(icon: Icons.groups_rounded, label: 'Khách hàng'),
    _AdminNavItem(icon: Icons.settings_rounded, label: 'Cài đặt'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = currentIndex == index;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTap(index),
                child: SizedBox(
                  height: 58,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: selected ? AppColors.neon : AppColors.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.label,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColors.neon
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: selected ? 6 : 0,
                        height: selected ? 6 : 0,
                        decoration: const BoxDecoration(
                          color: AppColors.neon,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _AdminNavItem {
  const _AdminNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
