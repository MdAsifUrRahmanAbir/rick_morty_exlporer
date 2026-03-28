import 'package:flutter/material.dart';
import '../../../widgets/responsive.dart';
import '../../character_screen/model/character_model.dart';
import 'character_detail_mobile_screen.dart';
import 'character_detail_tab_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  static const route = '/characterDetailScreen';
  final CharacterModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: CharacterDetailMobileScreen(character: character),
      tablet: CharacterDetailTabScreen(character: character),
    );
  }
}
