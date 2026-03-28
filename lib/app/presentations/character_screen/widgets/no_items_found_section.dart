import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/text_widget.dart';
import '../provider/character_screen_provider.dart';

class NoItemsFoundSection extends StatelessWidget {
  final CharacterScreenProvider provider;

  const NoItemsFoundSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          TextWidget.body(AppStrings.noItemsFound),
          const SizedBox(height: 16),
          if (provider.searchQuery.isNotEmpty || 
              provider.statusFilter.isNotEmpty || 
              provider.speciesFilter.isNotEmpty)
            PrimaryButton(
              text: 'Clear All Filters',
              onPressed: () => provider.clearFilters(),
            ),
        ],
      ),
    );
  }
}
