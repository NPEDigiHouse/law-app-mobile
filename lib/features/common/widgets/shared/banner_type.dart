import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class BannerType {
  final String leadingIconName;
  final Color backgroundColor;
  final Color foregroundColor;

  const BannerType(
    this.leadingIconName,
    this.backgroundColor,
    this.foregroundColor,
  );

  static BannerType error = const BannerType(
    'times-circle-line.svg',
    errorColor,
    scaffoldBackgroundColor,
  );
  static BannerType success = const BannerType(
    'check-circle-line.svg',
    successColor,
    scaffoldBackgroundColor,
  );
  static BannerType info = const BannerType(
    'exclamation-circle-line.svg',
    infoColor,
    scaffoldBackgroundColor,
  );
  static BannerType warning = const BannerType(
    'exclamation-circle-line.svg',
    warningColor,
    scaffoldBackgroundColor,
  );
}
