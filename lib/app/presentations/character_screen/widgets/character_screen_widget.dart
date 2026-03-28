import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/constants/app_sizes.dart';
import '../model/character_model.dart';
import '../../favorites/provider/favorites_provider.dart';
import '../provider/character_screen_provider.dart';
import 'character_card_widget.dart';
import 'search_and_filter_section.dart';
import 'no_items_found_section.dart';
import 'error_view_section.dart';

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
        SearchAndFilterSection(provider: provider, isDark: isDark),
        
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
                firstPageProgressIndicatorBuilder: (_) => _buildSkeletonGrid(),
                firstPageErrorIndicatorBuilder: (context) => ErrorViewSection(provider: provider),
                noItemsFoundIndicatorBuilder: (_) => NoItemsFoundSection(provider: provider),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonGrid() {
    return Column(
      children: List.generate(3, (index) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(child: AspectRatio(aspectRatio: 0.75, child: _buildDummyCard())),
              const SizedBox(width: 16),
              Expanded(child: AspectRatio(aspectRatio: 0.75, child: _buildDummyCard())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDummyCard() {
    return CharacterCardWidget(
      character: CharacterModel(
        id: 0,
        name: 'Loading Name',
        status: 'Alive',
        species: 'Species',
        type: '',
        gender: 'Gender',
        origin: CharacterLocation(name: 'Origin', url: ''),
        location: CharacterLocation(name: 'Location', url: ''),
        image: '',
        episode: [],
        url: '',
        created: DateTime.now(),
      ),
      onTap: () {},
    );
  }
}
