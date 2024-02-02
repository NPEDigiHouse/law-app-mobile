import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? checkboxLabel;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.checkboxLabel,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.primaryButtonText,
    this.secondaryButtonText,
  });

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  late final ValueNotifier<bool> isChecked;

  @override
  void initState() {
    super.initState();

    isChecked = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isChecked.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: widget.title,
      onPressedPrimaryButton: widget.onPressedPrimaryButton,
      onPressedSecondaryButton: widget.onPressedSecondaryButton,
      primaryButtonText: widget.primaryButtonText,
      secondaryButtonText: widget.secondaryButtonText,
      children: [
        Text(widget.message),
        const SizedBox(
          height: 8,
        ),
        if (widget.checkboxLabel != null)
          ValueListenableBuilder(
            valueListenable: isChecked,
            builder: (context, val, child) => ListTileTheme(
              minVerticalPadding: 4,
              child: CheckboxListTile(
                title: Text(
                  widget.checkboxLabel!,
                  style: textTheme.bodyMedium!.copyWith(
                    color: primaryTextColor,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                value: val,
                onChanged: (bool? value) => isChecked.value = value!,
              ),
            ),
          ),
      ],
    );
  }
}
