import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class UploadPlaceholder extends StatelessWidget {
  const UploadPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHighest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.neon,
              size: 34,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'UPLOAD HERO IMAGE',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
          ),
          const SizedBox(height: 14),
          const Text(
            'Drag and drop high-res photography here or click to browse.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'PNG, JPG, WEBP • MAX 10MB',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
