import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class EditContactUsDialog extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final VoidCallback? onPressedPrimaryButton;
  final String? primaryButtonText;

  const EditContactUsDialog({
    super.key,
    required this.items,
    this.onPressedPrimaryButton,
    this.primaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Edit Kontak Kami",
      onPressedPrimaryButton: onPressedPrimaryButton,
      primaryButtonText: primaryButtonText,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const Divider(
            color: secondaryTextColor,
          );
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                    textInputAction: TextInputAction.next,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi",
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    name: items[index]["linkName"],
                    label: items[index]["linkLabel"],
                    hintText: items[index]["linkHint"],
                    initialValue: items[index]["linkValue"],
                    hasPrefixIcon: false,
                    hasSuffixIcon: false,
                    textInputType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi",
                      ),
                      FormBuilderValidators.url(
                        errorText: "Link tidak valid",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
