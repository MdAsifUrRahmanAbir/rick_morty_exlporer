import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../character_screen/model/character_model.dart';
import '../../character_screen/provider/character_screen_provider.dart';
import '../../character_detail/provider/character_detail_provider.dart';
import '../../favorites/provider/favorites_provider.dart';
import '../provider/edit_character_provider.dart';
import '../widgets/edit_character_widget.dart';
import '../../../widgets/primary_appbar_widget.dart';

class EditCharacterMobileScreen extends StatelessWidget {
  final CharacterModel character;

  const EditCharacterMobileScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.read<EditCharacterProvider>();

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: PrimaryAppBar(
        title: AppStrings.editCharacter,
        centerTitle: false,
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
