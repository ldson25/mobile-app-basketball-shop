import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProductInputField extends StatelessWidget {
  const ProductInputField({
    super.key,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    this.large = false,
  });

  final String label;
  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefix != null) ...[
              prefix!,
              const SizedBox(width: 10),
            ],
            Expanded(
              child: TextField(
                maxLines: large ? 4 : 1,
                minLines: large ? 4 : 1,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  suffixIcon: suffix,
                  suffixIconConstraints: const BoxConstraints(minWidth: 24),
                  contentPadding: large
                      ? const EdgeInsets.all(16)
                      : const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: large
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: AppColors.border),
                        )
                      : const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                  focusedBorder: large
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: AppColors.neon, width: 1.6),
                        )
                      : const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.neon, width: 1.6),
                        ),
                ),
                style: TextStyle(
                  fontSize: large ? 16 : 18,
                  fontWeight: large ? FontWeight.w500 : FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
