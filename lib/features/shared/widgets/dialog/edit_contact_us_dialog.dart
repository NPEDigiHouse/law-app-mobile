// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/styles/color_scheme.dart';

import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class EditContactUsDialog extends StatelessWidget {
  final List<Map<String, dynamic>>
      items; /* 
        {
          "formName" -> String, 
          "formLabel" -> String, 
          "formHint" -> String, 
          "formValue" -> String, 
          "textInputType" -> TextInputType, 
          "formValidator" -> [FormBuilderValidator], 
          "linkName" -> String, 
          "linkLabel" -> String, 
          "linkHint" -> String, 
          "linkValue" -> String,
        } 
      */
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;

  const EditContactUsDialog({
    super.key,
    required this.items,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.primaryButtonText,
    this.secondaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Edit Kontak Kami",
      onPressedPrimaryButton: onPressedPrimaryButton,
      onPressedSecondaryButton: onPressedSecondaryButton,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      children: [
        ListView.separated(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: secondaryTextColor,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FormBuilder(
                child: Column(
                  children: [
                    CustomTextField(
                      name: items[index]["formName"],
                      label: items[index]["formLabel"],
                      hintText: items[index]["formHint"],
                      initialValue: items[index]["formValue"],
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      textInputType: items[index]["textInputType"],
                      textInputAction: TextInputAction.next,
                      validators: items[index]["formValidator"],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      name: items[index]["linkName"],
                      label: items[index]["linkLabel"],
                      hintText: items[index]["linkHint"],
                      initialValue: items[index]["linkValue"],
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Bagian ini harus diisi",
                        ),
                        FormBuilderValidators.url(errorText: "Link tidak valid")
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
