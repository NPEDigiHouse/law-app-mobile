// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class EditContactUsDialog extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String? primaryButtonText;
  final VoidCallback? onPressedPrimaryButton;

  const EditContactUsDialog({
    super.key,
    required this.items,
    this.primaryButtonText,
    this.onPressedPrimaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Edit Kontak Kami",
      primaryButtonText: primaryButtonText,
      onPressedPrimaryButton: onPressedPrimaryButton,
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
                    name: "name",
                    label: items[index]["contactName"],
                    hintText: "Masukkan ${items[index]["contactName"]}",
                    initialValue: items[index]["text"],
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
                    name: "link",
                    label: "Link",
                    hintText: "Masukkan link tujuan",
                    initialValue: "",
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
