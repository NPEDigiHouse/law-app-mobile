import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class SingleFormDialog extends StatelessWidget {
  final String title;
  final String name;
  final String label;
  final String hintText;
  final int? maxLines;
  final VoidCallback? onPressedPrimaryButton;
  final String? primaryButtonText;

  const SingleFormDialog({
    super.key,
    required this.title,
    required this.name,
    required this.label,
    required this.hintText,
    this.maxLines,
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
            child: CustomTextField(
              name: name,
              label: label,
              hintText: hintText,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              maxLines: maxLines,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
