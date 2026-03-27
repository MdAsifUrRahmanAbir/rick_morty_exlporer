import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/text_widget.dart';
import '../../../data/models/character_model.dart';
import '../../character_screen/provider/character_screen_provider.dart';
import '../../character_detail/provider/character_detail_provider.dart';
import '../../favorites/provider/favorites_provider.dart';
import '../provider/edit_character_provider.dart';
import '../widgets/edit_character_widget.dart';

class EditCharacterMobileScreen extends StatelessWidget {
  final CharacterModel character;

  const EditCharacterMobileScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.read<EditCharacterProvider>();

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        title: TextWidget.headlineMedium(AppStrings.editCharacter, color: AppColors.textPrimaryColor(isDark)),
        backgroundColor: AppColors.background(isDark),
        centerTitle: false,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: EditCharacterWidget(
        character: character,
        onSave: (data) async {
          await provider.updateCharacterLocal(character.id, data);
          if (context.mounted) {
            // Refresh list and detail screens
            context.read<CharacterScreenProvider>().refresh();
            context.read<CharacterDetailProvider>().refresh();
            context.read<FavoritesProvider>().refresh();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Character updated successfully!')),
            );
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
