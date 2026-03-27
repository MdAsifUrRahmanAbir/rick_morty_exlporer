import 'dart:async';
import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../character_screen/view/characters_screen.dart';

class SplashProvider extends ChangeNotifier {
  SplashProvider() {
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(seconds: 2), () {
      _goToScreen();
    });
  }

  void _goToScreen() {
    AppPages.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      CharactersScreen.route,
      (route) => false,
    );
  }
}
