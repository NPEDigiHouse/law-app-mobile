// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class EditContactUsDialog extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const EditContactUsDialog({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Edit Kontak Kami",
      primaryButtonText: 'Edit',
      onPressedPrimaryButton: () {},
      childPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return FormBuilder(
            child: Column(
              children: [
                CustomTextField(
                  isSmall: true,
                  name: "name",
                  label: "${items[index]["contact"]}",
                  hintText: "Masukkan ${items[index]["contact"]}",
                  initialValue: "",
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
                  name: "link",
                  label: "Link ${items[index]["contact"]}",
                  hintText: "Masukkan link ${items[index]["contact"]}",
                  initialValue: "",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  textInputType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: "Bagian ini harus diisi",
                    ),
                    FormBuilderValidators.url(
                      errorText: "Link tidak valid",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
