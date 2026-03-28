import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../character_screen/model/character_model.dart';
import 'character_detail_header.dart';
import 'character_info_card.dart';
import 'character_location_card.dart';

class CharacterDetailWidget extends StatelessWidget {
  final CharacterModel char;
  final bool isDark;

  const CharacterDetailWidget({
    super.key,
    required this.char,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CharacterDetailHeader(char: char, isDark: isDark),
          const SizedBox(height: 24),
          _buildInfoGrid(context),
          const SizedBox(height: 24),
          CharacterLocationCard(
            label: 'ORIGIN', 
            value: char.origin.name, 
            icon: Icons.public, 
            isDark: isDark
          ),
          const SizedBox(height: 16),
          CharacterLocationCard(
            label: 'LAST KNOWN LOCATION', 
            value: char.location.name, 
            icon: Icons.location_on, 
            isDark: isDark
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final displayType = char.type.isEmpty ? 'N/A' : char.type;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CharacterInfoCard(
                label: 'GENDER', 
                value: char.gender, 
                icon: Icons.face, 
                isDark: isDark
              )
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CharacterInfoCard(
                label: 'SPECIES', 
                value: char.species, 
                icon: Icons.category, 
                isDark: isDark
              )
            ),
          ],
        ),
        const SizedBox(height: 16),
        CharacterInfoCard(
          label: 'TYPE', 
          value: displayType, 
          icon: Icons.info_outline, 
          isDark: isDark
        ),
      ],
    );
  }
}
