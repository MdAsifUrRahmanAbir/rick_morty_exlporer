import 'package:flutter/material.dart';
import '../model/character_model.dart';
import 'character_card_widget.dart';

class CharacterSkeletonGrid extends StatelessWidget {
  const CharacterSkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(child: AspectRatio(aspectRatio: 0.75, child: _buildDummyCard())),
              const SizedBox(width: 16),
              Expanded(child: AspectRatio(aspectRatio: 0.75, child: _buildDummyCard())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDummyCard() {
    return CharacterCardWidget(
      character: CharacterModel(
        id: 0,
        name: 'Loading Name',
        status: 'Alive',
        species: 'Species',
        type: '',
        gender: 'Gender',
        origin: CharacterLocation(name: 'Origin', url: ''),
        location: CharacterLocation(name: 'Location', url: ''),
        image: '',
        episode: [],
        url: '',
        created: DateTime.now(),
      ),
      onTap: () {},
    );
  }
}
