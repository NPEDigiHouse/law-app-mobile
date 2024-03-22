// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/reference_models/contact_us_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/contact_us_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';

class EditContactUsDialog extends ConsumerWidget {
  final ContactUsModel? contact;

  const EditContactUsDialog({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return CustomDialog(
      title: 'Edit Kontak Kami',
      primaryButtonText: 'Edit',
      onPressedPrimaryButton: () {
        FocusManager.instance.primaryFocus?.unfocus();

        if (formKey.currentState!.saveAndValidate()) {
          final value = formKey.currentState!.value;

          navigatorKey.currentState!.pop();

          ref.read(contactUsProvider.notifier).editContactUs(
                contact: contact != null
                    ? contact!.copyWith(
                        whatsappLink: value['whatsappLink'],
                        emailLink: value['emailLink'],
                        addressName: value['addressName'],
                        addressLink: value['addressLink'],
                      )
                    : ContactUsModel(
                        whatsappName: value['whatsappLink'],
                        whatsappLink: value['whatsappLink'],
                        emailName: value['emailLink'],
                        emailLink: value['emailLink'],
                        addressName: value['addressName'],
                        addressLink: value['addressLink'],
                      ),
              );
        }
      },
      childPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: FormBuilder(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              isSmall: true,
              name: 'whatsappLink',
              label: 'No. WhatsApp',
              hintText: '62xxx (tanpa diawali tanda "+")',
              initialValue: contact?.whatsappLink,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputType: TextInputType.number,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Bagian ini harus diisi',
                ),
                FormBuilderValidators.integer(
                  errorText: 'Nomor tidak valid',
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: 'emailLink',
              label: 'Email',
              hintText: 'Masukkan email',
              initialValue: contact?.emailLink,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputType: TextInputType.emailAddress,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Bagian ini harus diisi',
                ),
                FormBuilderValidators.email(
                  errorText: 'Email tidak valid',
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: 'addressName',
              label: 'Alamat',
              hintText: 'Masukkan alamat',
              initialValue: contact?.addressName,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Bagian ini harus diisi',
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: 'addressLink',
              label: 'Link Alamat',
              hintText: 'Masukkan link alamat',
              initialValue: contact?.addressLink,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.done,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Bagian ini harus diisi',
                ),
                FormBuilderValidators.url(
                  errorText: 'Link tidak valid',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
