import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/text_widget.dart';

class CharacterInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const CharacterInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: isDark ? 0.1 : 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 12),
          TextWidget.caption(label, color: AppColors.textHint),
          const SizedBox(height: 4),
          TextWidget.body(value, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
