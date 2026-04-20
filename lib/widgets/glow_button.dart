import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GlowButton extends StatelessWidget {
  const GlowButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.expanded = false,
    this.isPrimary = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expanded;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon == null
          ? const SizedBox.shrink()
          : Icon(icon, size: 18, color: isPrimary ? Colors.black : Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isPrimary ? AppColors.neon : AppColors.surfaceHighest,
        foregroundColor: isPrimary ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(
            color: isPrimary ? AppColors.neon : AppColors.border,
          ),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );

    final wrapped = isPrimary
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55CCFD00),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: child,
          )
        : child;

    return expanded ? SizedBox(width: double.infinity, child: wrapped) : wrapped;
  }
}
