import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../character_screen/model/character_model.dart';
import '../../character_screen/provider/character_screen_provider.dart';
import '../../favorites/provider/favorites_provider.dart';
import '../provider/character_detail_provider.dart';
import '../widgets/character_detail_widget.dart';
import '../../edit_character/view/edit_character_screen.dart';
import '../../character_screen/view/characters_screen.dart';

class CharacterDetailMobileScreen extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailMobileScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<CharacterDetailProvider>();
    final char = provider.applyOverrides(character);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background(isDark),
        body: Stack(
          children: [
            // Main Body with scrollable content
            CustomScrollView(
              slivers: [
                // Immersive Transparent Header with Image
                SliverAppBar(
                  expandedHeight: 400.0,
                  pinned: true,
                  backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
                  elevation: 0,
                  // Effectively remove default app bar elements as we overlay them manually for precision
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: char.image,
                          fit: BoxFit.cover,
                        ),
                        // Optional Gradient overlay for better button visibility if needed
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black38, Colors.transparent, Colors.transparent],
                              stops: [0.0, 0.2, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Detail Content
                SliverToBoxAdapter(
                  child: CharacterDetailWidget(char: char, isDark: isDark),
                ),
              ],
            ),
            
            // Overlay UI Elements (Back, Edit, Favorite Buttons)
            _buildOverlayUI(context, char, isDark),
          ],
        ),
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    // Navigates back to the main characters screen and clears all previous routes (similar to Get.offAllNamed)
    Navigator.of(context).pushNamedAndRemoveUntil(
      CharactersScreen.route, 
      (route) => false,
    );
  }

  Widget _buildOverlayUI(BuildContext context, CharacterModel char, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            _buildCircularButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () => _handleBackNavigation(context),
            ),
            
            // Trailing Actions (Favorite and Edit)
            Row(
              children: [
                _buildCircularButton(
                  icon: context.watch<CharacterScreenProvider>().isFavorite(char.id) 
                      ? Icons.favorite_rounded 
                      : Icons.favorite_border_rounded,
                  iconColor: Colors.redAccent,
                  onPressed: () {
                    context.read<CharacterScreenProvider>().toggleFavorite(char);
                    context.read<FavoritesProvider>().refresh();
                  },
                ),
                const SizedBox(width: 12),
                _buildCircularButton(
                  icon: Icons.edit_rounded,
                  onPressed: () => Navigator.of(context).pushNamed(
                    EditCharacterScreen.route,
                    arguments: char,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon, 
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
