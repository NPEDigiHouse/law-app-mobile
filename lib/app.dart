import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:law_app/core/themes/light_theme.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/common/splash/splash_page.dart';

class LawApp extends StatelessWidget {
  const LawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Law App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorObservers: [routeObserver],
      onGenerateRoute: generateAppRoutes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('id', 'ID'), // Indonesia
      ],
      home: const SplashPage(),
    );
  }
}
