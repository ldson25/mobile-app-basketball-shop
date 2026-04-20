import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KineticBottomNav extends StatelessWidget {
  const KineticBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = <_NavItem>[
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.admin_panel_settings_rounded, label: 'Admin'),
      _NavItem(icon: Icons.local_shipping_rounded, label: 'Orders'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

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
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = currentIndex == index;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: selected ? AppColors.neon : AppColors.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? AppColors.neon
                              : AppColors.textMuted,
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

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
