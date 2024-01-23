import 'dart:async';
import 'package:flutter/material.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/features/common/shared/banner_type.dart';
import 'package:law_app/features/common/shared/confirm_dialog.dart';
import 'package:law_app/features/common/shared/loading_indicator.dart';

extension Capitalize on String {
  String toCapitalize() {
    return split(' ').map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length)}';
    }).join(' ');
  }
}

extension FilledButtonFullWidth on FilledButton {
  SizedBox fullWidth() {
    return SizedBox(
      width: double.infinity,
      child: this,
    );
  }
}

extension OutlinedButtonFullWidth on OutlinedButton {
  SizedBox fullWidth() {
    return SizedBox(
      width: double.infinity,
      child: this,
    );
  }
}

extension NavigationExtension on BuildContext {
  void back() {
    scaffoldMessengerKey.currentState!.hideCurrentMaterialBanner();
    navigatorKey.currentState!.pop();
  }
}

extension DialogExtension on BuildContext {
  Future<void> showLoadingDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const LoadingIndicator(),
    );
  }

  Future<Object?> showConfirmDialog({
    required String title,
    required String message,
    VoidCallback? onPressedPrimaryButton,
    VoidCallback? onPressedSecondaryButton,
    String? primaryButtonText,
    String? secondaryButtonText,
  }) {
    return showDialog<Object?>(
      context: this,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        onPressedPrimaryButton: onPressedPrimaryButton,
        onPressedSecondaryButton: onPressedSecondaryButton,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
      ),
    );
  }
}

extension BannerExtension on BuildContext {
  void showBanner({
    required String message,
    required BannerType type,
  }) {
    final banner = WidgetUtils.createMaterialBanner(
      message: message,
      type: type,
    );

    scaffoldMessengerKey.currentState!
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(banner);
  }
}
