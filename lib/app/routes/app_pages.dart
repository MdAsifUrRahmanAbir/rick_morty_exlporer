import 'package:flutter/material.dart';
import '../presentations/splash/views/splash_view.dart';
import '../presentations/character_screen/view/characters_screen.dart';
import '../presentations/character_detail/view/character_detail_screen.dart';
import '../presentations/favorites/view/favorites_screen.dart';
import '../presentations/edit_character/view/edit_character_screen.dart';

// Import centralized model
import '../data/models/character_model.dart';

class AppPages {
  AppPages._();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static const initial = SplashView.route;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashView.route:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case CharactersScreen.route:
        return MaterialPageRoute(builder: (_) => const CharactersScreen());
      case FavoritesScreen.route:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case CharacterDetailScreen.route:
        final char = settings.arguments as CharacterModel;
        return MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: char));
      case EditCharacterScreen.route:
        final char = settings.arguments as CharacterModel;
        return MaterialPageRoute(builder: (_) => EditCharacterScreen(character: char));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
