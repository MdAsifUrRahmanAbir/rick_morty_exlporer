import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/text_widget.dart';
import '../widgets/favorites_widget.dart';
import '../../character_detail/view/character_detail_screen.dart';

class FavoritesTabScreen extends StatelessWidget {
  const FavoritesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        title: TextWidget.headlineLarge(AppStrings.favorites, color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      body: FavoritesWidget(
        onCharacterTap: (item) => Navigator.of(context).pushNamed(
          CharacterDetailScreen.route,
          arguments: item,
        ),
        crossAxisCount: 3, // More columns for tablet
      ),
    );
  }
}
