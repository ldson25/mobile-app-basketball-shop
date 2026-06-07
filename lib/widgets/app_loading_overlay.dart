import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../services/app_loading_service.dart';

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppLoadingService>().isLoading;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(0.18),
                child: Center(
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      color: AppColors.neon,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
