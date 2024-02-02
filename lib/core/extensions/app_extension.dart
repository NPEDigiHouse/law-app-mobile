import 'dart:async';
import 'package:flutter/material.dart';
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/features/shared/profile/presentation/widgets/change_password_dialog.dart';
import 'package:law_app/features/shared/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/confirm_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_alert_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/edit_contact_us_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/one_form_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/one_form_with_text_area_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/sorting_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/type_selector_dialog.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

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
    String? checkboxLabel,
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
        checkboxLabel: checkboxLabel,
        onPressedPrimaryButton: onPressedPrimaryButton,
        onPressedSecondaryButton: onPressedSecondaryButton,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
      ),
    );
  }

  Future<Object?> showEditProfileDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const EditProfileDialog(),
    );
  }

  Future<Object?> showChangePasswordDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const ChangePasswordDialog(),
    );
  }

  Future<Object?> showTypeSelectorDialog({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => TypeSelectorDialog(
        title: title,
        items: items,
      ),
    );
  }

  Future<Object?> showOneFormDialog({
    required String title,
    required String formName,
    required String formLabel,
    required String formHint,
    VoidCallback? onPressedPrimaryButton,
    VoidCallback? onPressedSecondaryButton,
    String? primaryButtonText,
    String? secondaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => OneFormDialog(
        title: title,
        formName: formName,
        formLabel: formLabel,
        formHint: formHint,
        onPressedPrimaryButton: onPressedPrimaryButton,
        onPressedSecondaryButton: onPressedSecondaryButton,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
      ),
    );
  }

  Future<Object?> showCustomAlertDialog({
    required String title,
    required String message,
    String? checkboxLabel,
    required bool isError,
    VoidCallback? onPressedPrimaryButton,
    VoidCallback? onPressedSecondaryButton,
  }) {
    debugPrint("Masuk di extension");
    return showDialog(
      context: this,
      builder: (_) => CustomAlertDialog(
        title: title,
        isError: isError,
        checkboxLabel: checkboxLabel,
        message: message,
        onPressedPrimaryButton: onPressedPrimaryButton,
        onPressedSecondaryButton: onPressedSecondaryButton,
      ),
    );
  }

  Future<Object?> showEditContactUsDialog({
    required List<Map<String, dynamic>> items,
    VoidCallback? onPressedPrimaryButton,
    VoidCallback? onPressedSecondaryButton,
    String? primaryButtonText,
    String? secondaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => EditContactUsDialog(
        items: items,
        onPressedPrimaryButton: onPressedPrimaryButton,
        onPressedSecondaryButton: onPressedSecondaryButton,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
      ),
    );
  }

  Future<Object?> showSortingDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const SortingDialog(),
    );
  }

  Future<Object?> showOneFormWithTextAreaDialog({
    required String title,
    required String formName,
    required String formLabel,
    required String formHint,
    required String textAreaName,
    required String textAreaLabel,
    required String textAreaHint,
    required int textAreaMaxLines,
    VoidCallback? onPressedPrimaryButton,
    VoidCallback? onPressedSecondaryButton,
    String? primaryButtonText,
    String? secondaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => OneFormWithTextAreaDialog(
        title: title,
        formName: formName,
        formLabel: formLabel,
        formHint: formHint,
        onPressedPrimaryButton: onPressedPrimaryButton,
        onPressedSecondaryButton: onPressedSecondaryButton,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        textAreaHint: textAreaHint,
        textAreaName: textAreaName,
        textAreaLabel: textAreaLabel,
        textAreaMaxLines: textAreaMaxLines,
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
