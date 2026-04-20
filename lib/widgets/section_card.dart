import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: border,
      ),
      child: child,
    );
  }
}
