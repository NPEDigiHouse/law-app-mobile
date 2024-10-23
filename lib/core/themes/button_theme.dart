// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

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

final segmentedButtonTheme = SegmentedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }

      return secondaryTextColor;
    }),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return secondaryColor;
      }

      return scaffoldBackgroundColor;
    }),
    textStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return textTheme.titleSmall;
      }

      return textTheme.bodyMedium;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    side: WidgetStateProperty.all(
      const BorderSide(
        style: BorderStyle.none,
      ),
    ),
    visualDensity: const VisualDensity(vertical: -2),
  ),
);
