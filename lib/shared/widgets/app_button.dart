import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool primary;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.primary = true,
    this.icon,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final bg = primary ? AppColors.volt : AppColors.surface3;
    final fg = primary ? Colors.black : Colors.white;

    return SizedBox(
      height: height,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: primary ? 8 : 0,
          shadowColor: primary
              ? AppColors.volt.withOpacity(0.25)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: primary
                ? BorderSide.none
                : BorderSide(color: AppColors.outline.withOpacity(0.35)),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
