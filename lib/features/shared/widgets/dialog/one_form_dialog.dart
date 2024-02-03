// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class OneFormDialog extends StatelessWidget {
  final String title;
  final String formName;
  final String formLabel;
  final String formHint;
  final int? maxLines;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;

  const OneFormDialog({
    super.key,
    required this.title,
    required this.formName,
    required this.formLabel,
    required this.formHint,
    this.maxLines,
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
            child: CustomTextField(
              name: formName,
              label: formLabel,
              hintText: formHint,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              maxLines: maxLines,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validators: [
                FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
