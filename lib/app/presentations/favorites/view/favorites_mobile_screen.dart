import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_appbar_widget.dart';
import '../widgets/favorites_widget.dart';
import '../../character_detail/view/character_detail_screen.dart';

class FavoritesMobileScreen extends StatelessWidget {
  const FavoritesMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: PrimaryAppBar(
        title: AppStrings.favorites,
        centerTitle: false,
      ),
      body: FavoritesWidget(
        onCharacterTap: (item) => Navigator.of(context).pushNamed(
          CharacterDetailScreen.route,
          arguments: item,
        ),
        crossAxisCount: 2,
      ),
    );
  }
}
