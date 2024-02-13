import 'dart:async';
import 'package:flutter/material.dart';
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:law_app/features/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/confirm_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_alert_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_selector_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/single_form_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/single_form_text_area_dialog.dart';
import 'package:law_app/features/shared/widgets/dialog/sorting_dialog.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/network_error_bottom_sheet.dart';

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
    bool withCheckbox = false,
    String? checkboxLabel,
    String? primaryButtonText,
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showDialog<Object?>(
      context: this,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        withCheckbox: withCheckbox,
        checkboxLabel: checkboxLabel,
        primaryButtonText: primaryButtonText,
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }

  Future<Object?> showCustomAlertDialog({
    required String title,
    required String message,
    Color? foregroundColor,
    Color? backgroundColor,
    bool withCheckbox = false,
    String? checkboxLabel,
    String? primaryButtonText,
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => CustomAlertDialog(
        title: title,
        message: message,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        withCheckbox: withCheckbox,
        checkboxLabel: checkboxLabel,
        primaryButtonText: primaryButtonText,
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }

  Future<Object?> showCustomSelectorDialog({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => CustomSelectorDialog(
        title: title,
        items: items,
      ),
    );
  }

  Future<Object?> showSingleFormDialog({
    required String title,
    required String name,
    required String label,
    required String hintText,
    int maxLines = 1,
    String? primaryButtonText,
    void Function(Map<String, dynamic> value)? onSubmitted,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SingleFormDialog(
        title: title,
        name: name,
        label: label,
        hintText: hintText,
        maxLines: maxLines,
        primaryButtonText: primaryButtonText,
        onSubmitted: onSubmitted,
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
    int textAreaMaxLines = 4,
    String? primaryButtonText,
    void Function(Map<String, dynamic> value)? onSubmitted,
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
        primaryButtonText: primaryButtonText,
        onSubmitted: onSubmitted,
      ),
    );
  }

  Future<Object?> showSortingDialog({
    required String title,
    required List<String> items,
    String? primaryButtonText,
    void Function(Map<String, dynamic> value)? onSubmitted,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => SortingDialog(
        title: title,
        items: items,
        primaryButtonText: primaryButtonText,
        onSubmitted: onSubmitted,
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

extension ModalBottomSheetExtension on BuildContext {
  Future<Object?> showNetworkErrorModalBottomSheet({
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    VoidCallback? onPressedPrimaryButton,
  }) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => NetworkErrorBottomSheet(
        isFixed: !isDismissible && !enableDrag,
        onPressedPrimaryButton: onPressedPrimaryButton,
      ),
    );
  }
}
