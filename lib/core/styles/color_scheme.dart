import 'package:flutter/material.dart';

// Main colors
const primaryColor = Color(0xFFE44C42);
const secondaryColor = Color(0xFFFBECEB);
const tertiaryColor = Color(0xFFF59993);
const accentColor = Color(0xFFE2CA51);

// Text colors
const primaryTextColor = Color(0xFF160706);
const secondaryTextColor = Color(0xFFC8C4C4);
const accentTextColor = Color(0xFFF4E69E);

// Background colors
const backgroundColor = Color(0xFFFAF6F6);
const scaffoldBackgroundColor = Color(0xFFFFFFFF);
const secondaryBackgroundColor = Color(0xFFE06961);

// System colors
const errorColor = Color(0xFFF23D16);
const successColor = Color(0xFF00AF54);
const infoColor = Color(0xFF21C7EC);
const warningColor = Color(0xFFF5C61D); // Color(0xFFFCF6DF)

// Gradient colors
class GradientColors {
  static const List<Color> redPastel = [
    Color(0xFFF4847D),
    Color(0xFFE44C42),
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
