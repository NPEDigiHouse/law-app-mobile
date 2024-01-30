import 'package:flutter/material.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.primaryButtonText,
    this.secondaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      onPressedPrimaryButton: onPressedPrimaryButton,
      onPressedSecondaryButton: onPressedSecondaryButton,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      children: [
        Text(message),
      ],
    );
  }
}
