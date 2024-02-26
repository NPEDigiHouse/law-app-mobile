// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class SingleFormTextAreaDialog extends StatelessWidget {
  final String title;
  final String textFieldName;
  final String textFieldLabel;
  final String textFieldHint;
  final String? textFieldInitialValue;
  final String textAreaName;
  final String textAreaLabel;
  final String textAreaHint;
  final String? textAreaInitialValue;
  final int textAreaMaxLines;
  final String? primaryButtonText;
  final void Function(Map<String, dynamic> value)? onSubmitted;

  const SingleFormTextAreaDialog({
    super.key,
    required this.title,
    required this.textFieldName,
    required this.textFieldLabel,
    required this.textFieldHint,
    required this.textAreaName,
    required this.textAreaLabel,
    required this.textAreaHint,
    this.textAreaMaxLines = 4,
    this.primaryButtonText,
    this.onSubmitted,
    this.textFieldInitialValue, this.textAreaInitialValue,
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
        child: Column(
          children: [
            CustomTextField(
              isSmall: true,
              name: textFieldName,
              label: textFieldLabel,
              hintText: textFieldHint,
              initialValue: textFieldInitialValue,
              maxLines: 1,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.next,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: textAreaName,
              label: textAreaLabel,
              hintText: textAreaHint,
              maxLines: textAreaMaxLines,
              initialValue: textAreaInitialValue,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.newline,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
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
