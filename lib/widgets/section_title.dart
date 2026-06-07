import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitle != null) ...[
          Text(
            subtitle!.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.volt,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
