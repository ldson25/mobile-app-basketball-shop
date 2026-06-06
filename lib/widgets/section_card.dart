import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

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
    final isLight = Theme.of(context).brightness == Brightness.light;
    final resolvedColor = isLight
        ? _lightCardColor(color ?? AppColors.surface)
        : color ?? AppColors.surface;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(24),
        border: border ??
            (isLight ? Border.all(color: const Color(0xFFE2E2E2)) : null),
      ),
      child: child,
    );
  }

  Color _lightCardColor(Color source) {
    if (source == AppColors.surface ||
        source == AppColors.surface2 ||
        source == AppColors.surface3 ||
        source == AppColors.surfaceHighest) {
      return Colors.white;
    }
    return source;
  }
}
