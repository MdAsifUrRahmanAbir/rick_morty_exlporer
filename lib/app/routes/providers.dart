import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../modules/splash/providers/splash_provider.dart';
import '../modules/character_screen/provider/character_screen_provider.dart';
import '../modules/character_detail/provider/character_detail_provider.dart';
import '../modules/favorites/provider/favorites_provider.dart';
import '../modules/edit_character/provider/edit_character_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => SplashProvider()),
    ChangeNotifierProvider(create: (_) => CharacterScreenProvider()),
    ChangeNotifierProvider(create: (_) => CharacterDetailProvider()),
    ChangeNotifierProvider(create: (_) => FavoritesProvider()),
    ChangeNotifierProvider(create: (_) => EditCharacterProvider()),
  ];
}
