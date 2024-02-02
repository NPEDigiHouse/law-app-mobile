import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class OneFormWithTextAreaDialog extends StatelessWidget {
  final String title;
  final String formName;
  final String formLabel;
  final String formHint;
  final String textAreaName;
  final String textAreaLabel;
  final String textAreaHint;
  final int textAreaMaxLines;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;

  const OneFormWithTextAreaDialog({
    super.key,
    required this.title,
    required this.formName,
    required this.formLabel,
    required this.formHint,
    required this.textAreaName,
    required this.textAreaLabel,
    required this.textAreaHint,
    required this.textAreaMaxLines,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FormBuilder(
            child: Column(
              children: [
                CustomTextField(
                  name: formName,
                  label: formLabel,
                  hintText: formHint,
                  maxLines: 1,
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi"),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  name: textAreaName,
                  label: textAreaLabel,
                  hintText: textAreaHint,
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  maxLines: textAreaMaxLines,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
