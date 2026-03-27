import 'package:flutter/material.dart';
import '../../../widgets/responsive.dart';
import 'character_mobile_screen.dart';
import 'character_tab_screen.dart';

class CharactersScreen extends StatelessWidget {
  static const route = '/charactersScreen';
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: CharacterMobileScreen(),
      tablet: CharacterTabScreen(),
    );
  }
}
