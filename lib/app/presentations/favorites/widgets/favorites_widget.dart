import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/character_model.dart';
import '../provider/favorites_provider.dart';
import '../../character_screen/provider/character_screen_provider.dart';
import '../../character_screen/widgets/character_card_widget.dart';
import 'no_favorites_found_widget.dart';

class FavoritesWidget extends StatelessWidget {
  final Function(CharacterModel) onCharacterTap;
  final int crossAxisCount;

  const FavoritesWidget({
    super.key,
    required this.onCharacterTap,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();
    final favoriteList = provider.favoriteCharacters;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (favoriteList.isEmpty) {
      return NoFavoritesFoundWidget(isDark: isDark);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: favoriteList.length,
      itemBuilder: (context, index) {
        final item = favoriteList[index];
        return CharacterCardWidget(
          character: item,
          onTap: () => onCharacterTap(item),
          trailing: IconButton(
            icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 22),
            onPressed: () {
              context.read<CharacterScreenProvider>().toggleFavorite(item);
              provider.refresh();
            },
          ),
        );
      },
    );
  }
}
