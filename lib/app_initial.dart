import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/core/services/local_storage_service.dart';
import 'app/core/theme/app_theme.dart';

class AppInitial {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ─── Init LocalStorage (SharedPreferences) ─────────────────────────
    await LocalStorage.init();

    // ─── System UI ────────────────────────────────────────────────────────────
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ─── Apply saved theme ────────────────────────────────────────────────────
    AppTheme.themeMode = LocalStorage.isDarkMode()
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
