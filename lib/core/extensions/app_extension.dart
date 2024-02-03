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
import 'package:law_app/features/shared/widgets/dialog/single_form_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/single_form_text_area_dialog.dart';
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
    String? primaryButtonText,
  }) {
    return showDialog<Object?>(
      context: this,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        checkboxLabel: checkboxLabel,
        onPressedPrimaryButton: onPressedPrimaryButton,
        primaryButtonText: primaryButtonText,
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

  Future<Object?> showSingleFormDialog({
    required String title,
    required String formName,
    required String label,
    required String hintText,
    int? maxLines,
    VoidCallback? onPressedPrimaryButton,
    String? primaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SingleFormDialog(
        title: title,
        name: formName,
        label: label,
        hintText: hintText,
        maxLines: maxLines,
        onPressedPrimaryButton: onPressedPrimaryButton,
        primaryButtonText: primaryButtonText,
      ),
    );
  }

  Future<Object?> showSingleFormTextAreaDialog({
    required String title,
    required String textFieldName,
    required String textFieldLabel,
    required String textFieldHint,
    required String textAreaName,
    required String textAreaLabel,
    required String textAreaHint,
    required int textAreaMaxLines,
    VoidCallback? onPressedPrimaryButton,
    String? primaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SingleFormTextAreaDialog(
        title: title,
        textFieldName: textFieldName,
        textFieldLabel: textFieldLabel,
        textFieldHint: textFieldHint,
        textAreaName: textAreaName,
        textAreaLabel: textAreaLabel,
        textAreaHint: textAreaHint,
        textAreaMaxLines: textAreaMaxLines,
        onPressedPrimaryButton: onPressedPrimaryButton,
        primaryButtonText: primaryButtonText,
      ),
    );
  }

  Future<Object?> showCustomAlertDialog({
    required String title,
    required String message,
    String? checkboxLabel,
    Color? foregroundColor,
    Color? backgroundColor,
    VoidCallback? onPressedPrimaryButton,
    String? primaryButtonText,
  }) {
    return showDialog(
      context: this,
      builder: (_) => CustomAlertDialog(
        title: title,
        message: message,
        checkboxLabel: checkboxLabel,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        onPressedPrimaryButton: onPressedPrimaryButton,
        primaryButtonText: primaryButtonText,
      ),
    );
  }

  Future<Object?> showEditContactUsDialog({
    required List<Map<String, dynamic>> items,
    VoidCallback? onPressedPrimaryButton,
    String? primaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => EditContactUsDialog(
        items: items,
        onPressedPrimaryButton: onPressedPrimaryButton,
        primaryButtonText: primaryButtonText,
      ),
    );
  }

  Future<Object?> showSortingDialog({
    required String title,
    required List<String> sortingItems,
    required ValueNotifier<String?> selectedFirstDropdown,
    required ValueNotifier<String?> selectedSecondDropdown,
    VoidCallback? onPressedPrimaryButton,
    String? primaryButtonText,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SortingDialog(
        title: title,
        sortingItems: sortingItems,
        selectedFirstDropdown: selectedFirstDropdown,
        selectedSecondDropdown: selectedSecondDropdown,
        onPressedPrimaryButton: onPressedPrimaryButton,
        primaryButtonText: primaryButtonText,
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
