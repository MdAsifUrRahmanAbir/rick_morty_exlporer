import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../data/models/character_model.dart';

class FavoritesProvider extends ChangeNotifier {
  
  List<CharacterModel> get favoriteCharacters {
    final raw = LocalStorage.getFavoriteObjects();
    return raw.map((json) => applyOverrides(CharacterModel.fromJson(json))).toList();
  }

  CharacterModel applyOverrides(CharacterModel char) {
    final override = LocalStorage.getOverride(char.id);
    if (override == null) return char;

    return char.copyWith(
      name: override['name'],
      status: override['status'],
      species: override['species'],
      type: override['type'],
      gender: override['gender'],
      origin: override['origin_name'] != null 
          ? CharacterLocation(name: override['origin_name'], url: char.origin.url) 
          : null,
      location: override['location_name'] != null 
          ? CharacterLocation(name: override['location_name'], url: char.location.url) 
          : null,
    );
  }

  void toggleFavorite(CharacterModel character) {
    if (LocalStorage.isFavoriteChar(character.id)) {
      LocalStorage.removeFavorite(character.id);
    } else {
      LocalStorage.saveFavorite(character.id, character.toJson());
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
