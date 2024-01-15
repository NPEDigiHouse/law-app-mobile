import 'package:flutter/material.dart';
import 'package:law_app/core/themes/light_theme.dart';
import 'package:law_app/features/common/splash/splash_page.dart';

class LawApp extends StatelessWidget {
  const LawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Law App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const SplashPage(),
    );
  }
}
