import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../../../widgets/text_widget.dart';
import '../../../data/models/character_model.dart';
import '../../favorites/provider/favorites_provider.dart';
import '../provider/character_screen_provider.dart';
import 'character_card_widget.dart';

class CharacterScreenWidget extends StatelessWidget {
  final Function(CharacterModel) onCharacterTap;
  final int crossAxisCount;

  const CharacterScreenWidget({
    super.key,
    required this.onCharacterTap,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharacterScreenProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Modern Search & Filter Header
        _buildSearchAndFilter(context, provider, isDark),
        
        // Character Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PagedGridView<int, CharacterModel>(
              pagingController: provider.pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              builderDelegate: PagedChildBuilderDelegate<CharacterModel>(
                itemBuilder: (context, item, index) => CharacterCardWidget(
                  character: item,
                  onTap: () => onCharacterTap(item),
                  trailing: IconButton(
                    icon: Icon(
                      provider.isFavorite(item.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(item);
                      context.read<FavoritesProvider>().refresh();
                    },
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                firstPageErrorIndicatorBuilder: (context) => _buildErrorView(context, provider),
                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.paddingMid),
                    child: CircularProgressIndicator(),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => _buildNoItemsView(provider),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, CharacterScreenProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: AppColors.background(isDark),
      child: Column(
        children: [
          // Search Bar
          PrimaryInputField(
            hint: AppStrings.searchHint,
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            onChanged: (val) => provider.setSearch(val),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Alive',
                  isSelected: provider.statusFilter == 'Alive',
                  onSelected: (selected) => provider.setFilters(status: selected ? 'Alive' : ''),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Dead',
                  isSelected: provider.statusFilter == 'Dead',
                  onSelected: (selected) => provider.setFilters(status: selected ? 'Dead' : ''),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Human',
                  isSelected: provider.speciesFilter == 'Human',
                  onSelected: (selected) => provider.setFilters(species: selected ? 'Human' : ''),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Alien',
                  isSelected: provider.speciesFilter == 'Alien',
                  onSelected: (selected) => provider.setFilters(species: selected ? 'Alien' : ''),
                ),
                const SizedBox(width: 12),
                if (provider.searchQuery.isNotEmpty || provider.statusFilter.isNotEmpty || provider.speciesFilter.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => provider.clearFilters(),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Reset'),
                    style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required Function(bool) onSelected}) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? Colors.white : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey[300]!),
      ),
    );
  }

  Widget _buildNoItemsView(CharacterScreenProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          TextWidget.body(AppStrings.noItemsFound),
          const SizedBox(height: 16),
          if (provider.searchQuery.isNotEmpty || provider.statusFilter.isNotEmpty || provider.speciesFilter.isNotEmpty)
            PrimaryButton(
              text: 'Clear All Filters',
              onPressed: () => provider.clearFilters(),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, CharacterScreenProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            TextWidget.titleMedium('No Internet Connection'),
            const SizedBox(height: 8),
            TextWidget.bodySmall(
              'Please check your connection and try again to see the latest characters.',
              textAlign: TextAlign.center,
              color: AppColors.grey,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: PrimaryButton(
                text: 'Try Again',
                onPressed: () => provider.refresh(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
