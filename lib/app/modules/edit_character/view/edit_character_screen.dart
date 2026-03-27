import 'package:flutter/material.dart';
import '../../../widgets/responsive.dart';
import '../../../data/models/character_model.dart';
import 'edit_character_mobile_screen.dart';
import 'edit_character_tab_screen.dart';

class EditCharacterScreen extends StatelessWidget {
  static const route = '/editCharacterScreen';
  final CharacterModel character;

  const EditCharacterScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: EditCharacterMobileScreen(character: character),
      tablet: EditCharacterTabScreen(character: character),
    );
  }
}
