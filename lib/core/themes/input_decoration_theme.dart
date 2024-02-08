import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

final inputDecorationTheme = InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: errorColor,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: errorColor,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: secondaryTextColor,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: accentColor,
    ),
  ),
  hintStyle: textTheme.bodyLarge!.copyWith(
    color: secondaryTextColor,
  ),
);
