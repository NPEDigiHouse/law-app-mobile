// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/contact_us_models/contact_us_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/contact_us_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class EditContactUsDialog extends ConsumerWidget {
  final List<Map<String, dynamic>> items;

  const EditContactUsDialog({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return CustomDialog(
      title: "Edit Kontak Kami",
      primaryButtonText: 'Edit',
      onPressedPrimaryButton: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState!.saveAndValidate()) {
          final value = formKey.currentState!.value;
          ref.read(contactUsProvider.notifier).editContactUs(
                contact: ContactUsModel(
                  whatsappName: value['whatsappName'],
                  whatsappLink: value['whatsappLink'],
                  emailName: value['emailName'],
                  emailLink: value['emailLink'],
                  addressName: value['addressName'],
                  addressLink: value['addressLink'],
                ),
              );
          navigatorKey.currentState!.pop();
        }
      },
      childPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: FormBuilder(
        key: formKey,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            debugPrint("${items[index]["contact"]}");
            return Column(
              children: [
                CustomTextField(
                  isSmall: true,
                  name: "${items[index]["formLabel"]}Name",
                  label: "${items[index]["contact"]}",
                  hintText: "Masukkan ${items[index]["contact"]}",
                  initialValue: "${items[index]["contactName"]}",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: "Bagian ini harus diisi",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  isSmall: true,
                  name: "${items[index]["formLabel"]}Link",
                  label: "Link ${items[index]["contact"]}",
                  hintText: "Masukkan link ${items[index]["contact"]}",
                  initialValue: "${items[index]["link"]}",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  textInputType: TextInputType.url,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: "Bagian ini harus diisi",
                    ),
                    FormBuilderValidators.url(
                      errorText: "Format tidak valid",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
