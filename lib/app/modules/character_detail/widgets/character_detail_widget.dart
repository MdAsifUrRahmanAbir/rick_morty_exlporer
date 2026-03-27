import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/text_widget.dart';
import '../../../data/models/character_model.dart';

class CharacterDetailWidget extends StatelessWidget {
  final CharacterModel char;
  final bool isDark;

  const CharacterDetailWidget({
    super.key,
    required this.char,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Area
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMid),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildInfoGrid(context),
                const SizedBox(height: 24),
                _buildLocationCard('ORIGIN', char.origin.name, Icons.public),
                const SizedBox(height: 16),
                _buildLocationCard('LAST KNOWN LOCATION', char.location.name, Icons.location_on),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: TextWidget.headlineLarge(char.name)),
            _buildStatusBadge(),
          ],
        ),
        const SizedBox(height: 8),
        TextWidget.body('${char.species} • ${char.gender}', color: AppColors.textSecondaryColor(isDark)),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final color = _getStatusColor(char.status);
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
          TextWidget.badge(char.status.toUpperCase(), color: color),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildInfoCard('GENDER', char.gender, Icons.face)),
        const SizedBox(width: 16),
        Expanded(child: _buildInfoCard('SPECIES', char.species, Icons.category)),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
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

  Widget _buildLocationCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: isDark ? 0.1 : 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.caption(label, color: AppColors.textHint),
                const SizedBox(height: 4),
                TextWidget.body(value, fontWeight: FontWeight.bold),
              ],
            ),
          ),
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
