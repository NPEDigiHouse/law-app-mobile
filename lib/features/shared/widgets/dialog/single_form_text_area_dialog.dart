import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class SingleFormTextAreaDialog extends StatelessWidget {
  final String title;
  final String textFieldName;
  final String textFieldLabel;
  final String textFieldHint;
  final String textAreaName;
  final String textAreaLabel;
  final String textAreaHint;
  final int? textAreaMaxLines;
  final VoidCallback? onPressedPrimaryButton;
  final String? primaryButtonText;

  const SingleFormTextAreaDialog({
    super.key,
    required this.title,
    required this.textFieldName,
    required this.textFieldLabel,
    required this.textFieldHint,
    required this.textAreaName,
    required this.textAreaLabel,
    required this.textAreaHint,
    this.textAreaMaxLines,
    this.onPressedPrimaryButton,
    this.primaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      onPressedPrimaryButton: onPressedPrimaryButton,
      primaryButtonText: primaryButtonText,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FormBuilder(
            child: Column(
              children: [
                CustomTextField(
                  name: textAreaName,
                  label: textFieldLabel,
                  hintText: textFieldHint,
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  textInputAction: TextInputAction.next,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: "Bagian ini harus diisi",
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  name: textAreaName,
                  label: textAreaLabel,
                  hintText: textAreaHint,
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  maxLines: textAreaMaxLines,
                  textInputAction: TextInputAction.newline,
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
