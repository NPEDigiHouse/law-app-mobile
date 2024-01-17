import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

final filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: secondaryColor,
    disabledBackgroundColor: backgroundColor,
    disabledForegroundColor: secondaryTextColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    disabledForegroundColor: secondaryTextColor,
    side: const BorderSide(color: primaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

final textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    disabledForegroundColor: secondaryTextColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
