import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/character_model.dart';
import '../../character_screen/provider/character_screen_provider.dart';
import '../../favorites/provider/favorites_provider.dart';
import '../provider/character_detail_provider.dart';
import '../widgets/character_detail_widget.dart';
import '../../edit_character/view/edit_character_screen.dart';

class CharacterDetailTabScreen extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailTabScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<CharacterDetailProvider>();
    final char = provider.applyOverrides(character);

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            leading: const BackButton(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {
                  provider.toggleFavorite(char);
                  context.read<FavoritesProvider>().refresh();
                  context.read<CharacterScreenProvider>().refresh();
                },
                icon: Icon(
                  provider.isFavorite(char.id) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  EditCharacterScreen.route,
                  arguments: char,
                ),
                icon: const Icon(Icons.edit, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: CachedNetworkImage(
                imageUrl: char.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        body: CharacterDetailWidget(char: char, isDark: isDark),
      ),
    );
  }
}
