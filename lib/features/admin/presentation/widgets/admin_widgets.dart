import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/section_card.dart';

class AdminPageScaffold extends StatelessWidget {
  const AdminPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final secondaryText =
        isLight ? Color(0xFF555555) : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSizes.pagePadding,
            8,
            AppSizes.pagePadding,
            122,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminTopBar(trailing: trailing),
              const SizedBox(height: 22),
              Text(
                title,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 34,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle.toUpperCase(),
                style: TextStyle(
                  color: secondaryText,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({super.key, this.trailing});

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final iconBg = isLight ? Colors.white : AppColors.surface2;
    final iconColor = isLight ? Color(0xFF111111) : AppColors.textPrimary;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
            border: isLight ? Border.all(color: const Color(0xFFE2E2E2)) : null,
          ),
          child: Icon(Icons.admin_panel_settings, color: AppColors.neon),
        ),
        const SizedBox(width: 12),
        Text(
          'KINETIC',
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: AppColors.neon,
          ),
        ),
        const Spacer(),
        trailing ??
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_rounded,
                color: iconColor,
              ),
            ),
      ],
    );
  }
}

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
  });

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? Color(0xFF111111) : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: TextStyle(
            color: AppColors.neon,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.delta,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? delta;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? Color(0xFF111111) : AppColors.textPrimary;
    final mutedColor = isLight ? Color(0xFF666666) : AppColors.textSecondary;

    return SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.neon,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.background, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                if (delta != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    delta!,
                    style: TextStyle(
                      color: AppColors.neon,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSearchField extends StatelessWidget {
  const AdminSearchField({
    super.key,
    required this.hint,
    this.icon = Icons.search_rounded,
    this.onChanged,
    this.controller,
  });

  final String hint;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? Color(0xFF111111) : AppColors.textPrimary;
    final mutedColor = isLight ? Color(0xFF777777) : AppColors.textMuted;

    return SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          Icon(icon, color: mutedColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: mutedColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminStatusChip extends StatelessWidget {
  const AdminStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.24)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

