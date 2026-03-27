import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/text_widget.dart';
import '../provider/character_screen_provider.dart';
import '../widgets/character_screen_widget.dart';
import '../../favorites/view/favorites_screen.dart';
import '../../character_detail/view/character_detail_screen.dart';

class CharacterTabScreen extends StatelessWidget {
  const CharacterTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        title: TextWidget.headlineLarge(AppStrings.characters, color: AppColors.textPrimaryColor(isDark)),
        backgroundColor: AppColors.background(isDark),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, FavoritesScreen.route),
            icon: const Icon(Icons.favorite_outline),
            color: AppColors.textPrimaryColor(isDark),
            iconSize: 28,
          ),
          IconButton(
            onPressed: () => context.read<CharacterScreenProvider>().refresh(),
            icon: const Icon(Icons.refresh),
            color: AppColors.textPrimaryColor(isDark),
            iconSize: 28,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CharacterScreenWidget(
        onCharacterTap: (item) => Navigator.of(context).pushNamed(
          CharacterDetailScreen.route,
          arguments: item,
        ),
        crossAxisCount: 3, // More columns for tablet
      ),
    );
  }
}
