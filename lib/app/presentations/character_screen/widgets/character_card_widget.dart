import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/character_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../widgets/text_widget.dart';
import '../provider/character_screen_provider.dart';

class CharacterCardWidget extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback onTap;
  final Widget? trailing;

  const CharacterCardWidget({
    super.key,
    required this.character,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdited = LocalStorage.getOverride(character.id) != null;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.divider.withValues(alpha: isDark ? 0.1 : 0.5)),
      ),
      color: AppColors.card(isDark),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Character Image - Full Width/Height with scaling
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: character.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.greyLight,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, err) => const Icon(Icons.broken_image),
              ),
            ),
            
            // Bottom Gradient Overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),

            if (isEdited)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.restore_rounded, size: 20, color: Colors.amberAccent),
                    tooltip: 'Reset to API Data',
                    onPressed: () => context.read<CharacterScreenProvider>().resetToApi(character.id),
                  ),
                ),
              ),

            // Content
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget.titleMedium(
                    character.name,
                    color: Colors.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(character.status),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextWidget.bodySmall(
                          '${character.species} • ${character.status}',
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Trailing / Favorite Icon
            if (trailing != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: trailing,
                ),
              ),
          ],
        ),
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
