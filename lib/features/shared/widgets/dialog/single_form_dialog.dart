// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class SingleFormDialog extends StatelessWidget {
  final String title;
  final String name;
  final String label;
  final String hintText;
  final String? initialValue;
  final int maxLines;
  final String? primaryButtonText;
  final void Function(Map<String, dynamic> value)? onSubmitted;

  const SingleFormDialog({
    super.key,
    required this.title,
    required this.name,
    required this.label,
    required this.hintText,
    this.initialValue,
    this.maxLines = 1,
    this.primaryButtonText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return CustomDialog(
      title: title,
      primaryButtonText: primaryButtonText,
      onPressedPrimaryButton: () => submit(formKey),
      child: FormBuilder(
        key: formKey,
        child: CustomTextField(
          isSmall: true,
          name: name,
          label: label,
          hintText: hintText,
          initialValue: initialValue,
          hasPrefixIcon: false,
          hasSuffixIcon: false,
          maxLines: maxLines,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.done,
          validators: [
            FormBuilderValidators.required(
              errorText: "Bagian ini harus diisi",
            ),
          ],
        ),
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    if (onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.saveAndValidate()) {
        onSubmitted!(formKey.currentState!.value);
      }
    }
  }
}
