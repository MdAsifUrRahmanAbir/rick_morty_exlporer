import 'package:flutter/material.dart';
import '../../../widgets/responsive.dart';
import 'favorites_mobile_screen.dart';
import 'favorites_tab_screen.dart';

class FavoritesScreen extends StatelessWidget {
  static const route = '/favoritesScreen';
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: FavoritesMobileScreen(),
      tablet: FavoritesTabScreen(),
    );
  }
}
