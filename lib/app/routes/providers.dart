import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../presentations/splash/providers/splash_provider.dart';
import '../presentations/character_screen/provider/character_screen_provider.dart';
import '../presentations/character_detail/provider/character_detail_provider.dart';
import '../presentations/favorites/provider/favorites_provider.dart';
import '../presentations/edit_character/provider/edit_character_provider.dart';

class AppProviders {
  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => SplashProvider()),
    ChangeNotifierProvider(create: (_) => CharacterScreenProvider()),
    ChangeNotifierProvider(create: (_) => CharacterDetailProvider()),
    ChangeNotifierProvider(create: (_) => FavoritesProvider()),
    ChangeNotifierProvider(create: (_) => EditCharacterProvider()),
  ];
}
