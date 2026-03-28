import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/text_widget.dart';
import '../../character_screen/model/character_model.dart';

class CharacterDetailHeader extends StatelessWidget {
  final CharacterModel char;
  final bool isDark;

  const CharacterDetailHeader({
    super.key,
    required this.char,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: TextWidget.headlineLarge(char.name)),
            _StatusBadge(status: char.status),
          ],
        ),
        const SizedBox(height: 8),
        TextWidget.body(
          '${char.species} • ${char.gender}', 
          color: AppColors.textSecondaryColor(isDark)
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          TextWidget.badge(status.toUpperCase(), color: color),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return Colors.greenAccent;
      case 'dead': return Colors.redAccent;
      default: return Colors.grey;
    }
  }
}
