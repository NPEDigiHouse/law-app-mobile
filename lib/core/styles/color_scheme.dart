// Flutter imports:
import 'package:flutter/material.dart';

// Main colors
const primaryColor = Color(0xFF730034);
const secondaryColor = Color(0xFFF4EBEF);
const tertiaryColor = Color(0xFFC799AE);
const accentColor = Color(0xFFF1D443);

// Text colors
const primaryTextColor = Color(0xFF160706);
const secondaryTextColor = Color(0xFFC8C4C4);
const accentTextColor = Color(0xFFF9E47A);

// Background colors
const backgroundColor = Color(0xFFFCFAFB);
const scaffoldBackgroundColor = Color(0xFFFFFFFF);

// System colors
const errorColor = Color(0xFFF23D16);
const successColor = Color(0xFF00AF54);
const infoColor = Color(0xFF21C7EC);
const warningColor = Color(0xFFF5C61D);

// Gradient colors
class GradientColors {
  static const List<Color> redPastel = [
    Color(0xFFA2355A),
    Color(0xFF730034),
  ];
}

// Color scheme
final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: primaryColor,
  primary: primaryColor,
  onPrimary: secondaryColor,
  secondary: secondaryColor,
  onSecondary: primaryColor,
  background: backgroundColor,
  onBackground: primaryTextColor,
  error: errorColor,
  onError: scaffoldBackgroundColor,
);
