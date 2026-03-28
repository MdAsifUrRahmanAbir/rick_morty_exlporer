import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/text_widget.dart';

class NoFavoritesFoundWidget extends StatelessWidget {
  final bool isDark;

  const NoFavoritesFoundWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : AppColors.primaryLight.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_rounded, 
              size: 64, 
              color: isDark ? Colors.white30 : AppColors.primary.withValues(alpha: 0.3)
            ),
          ),
          const SizedBox(height: 24),
          TextWidget.titleLarge(
            'No Favorites Found',
            color: isDark ? Colors.white70 : AppColors.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),
          TextWidget.body(
            'Go explore and add some characters to your favorites!',
            color: isDark ? Colors.white38 : AppColors.textSecondaryColor(isDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
