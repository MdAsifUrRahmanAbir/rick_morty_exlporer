import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/providers.dart';
import 'app_initial.dart';

Future<void> main() async {
  await AppInitial.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Rick & Morty Explorer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: AppTheme.themeMode,
        navigatorKey: AppPages.navigatorKey,
        scaffoldMessengerKey: AppPages.messengerKey,
        initialRoute: AppPages.initial,
        onGenerateRoute: AppPages.generateRoute,
      ),
    );
  }
}
