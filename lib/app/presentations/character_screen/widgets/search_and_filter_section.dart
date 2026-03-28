import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_input_field.dart';
import '../provider/character_screen_provider.dart';

class SearchAndFilterSection extends StatelessWidget {
  final CharacterScreenProvider provider;
  final bool isDark;

  const SearchAndFilterSection({
    super.key,
    required this.provider,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                _FilterChipWidget(
                  label: 'Alive',
                  isSelected: provider.statusFilter == 'Alive',
                  onSelected: (selected) => provider.setFilters(status: selected ? 'Alive' : ''),
                ),
                const SizedBox(width: 8),
                _FilterChipWidget(
                  label: 'Dead',
                  isSelected: provider.statusFilter == 'Dead',
                  onSelected: (selected) => provider.setFilters(status: selected ? 'Dead' : ''),
                ),
                const SizedBox(width: 8),
                _FilterChipWidget(
                  label: 'Human',
                  isSelected: provider.speciesFilter == 'Human',
                  onSelected: (selected) => provider.setFilters(species: selected ? 'Human' : ''),
                ),
                const SizedBox(width: 8),
                _FilterChipWidget(
                  label: 'Alien',
                  isSelected: provider.speciesFilter == 'Alien',
                  onSelected: (selected) => provider.setFilters(species: selected ? 'Alien' : ''),
                ),
                const SizedBox(width: 12),
                if (provider.searchQuery.isNotEmpty || 
                    provider.statusFilter.isNotEmpty || 
                    provider.speciesFilter.isNotEmpty)
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
}

class _FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _FilterChipWidget({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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
}
