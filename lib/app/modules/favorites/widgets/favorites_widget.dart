import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/text_widget.dart';
import '../../../data/models/character_model.dart';
import '../provider/favorites_provider.dart';

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

    if (favoriteList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            TextWidget.body(AppStrings.noFavoritesYet),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.gapMid,
        mainAxisSpacing: AppSizes.gapMid,
        childAspectRatio: 0.8,
      ),
      itemCount: favoriteList.length,
      itemBuilder: (context, index) {
        final item = favoriteList[index];
        return _FavoriteCardWidget(
          character: item,
          onTap: () => onCharacterTap(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => provider.toggleFavorite(item),
          ),
        );
      },
    );
  }
}

class _FavoriteCardWidget extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback onTap;
  final Widget? trailing;

  const _FavoriteCardWidget({
    required this.character,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.divider.withValues(alpha: 0.1),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingSmall),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget.titleMedium(
                        character.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      TextWidget.bodySmall(
                        '${character.species} • ${character.status}',
                        color: _getStatusColor(character.status),
                      ),
                    ],
                  ),
                  if (trailing != null)
                    Positioned(top: -6, right: -8, child: trailing!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return Colors.green;
      case 'dead': return Colors.red;
      default: return Colors.grey;
    }
  }
}
