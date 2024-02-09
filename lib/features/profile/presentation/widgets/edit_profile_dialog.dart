import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final formKey = GlobalKey<FormBuilderState>();

  var date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Edit Profil',
      onPressedPrimaryButton: editProfile,
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              isSmall: true,
              name: "name",
              label: "Nama Lengkap",
              hintText: "Masukkan nama lengkap kamu",
              initialValue: user.fullName,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
                FormBuilderValidators.match(
                  r'^[a-zA-Z\s]*$',
                  errorText: "Nama tidak valid",
                )
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: "username",
              label: "Username",
              hintText: "Masukkan username kamu",
              initialValue: user.username,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.next,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
                FormBuilderValidators.match(
                  r'^(?=.*[a-zA-Z])\d*[a-zA-Z\d]*$',
                  errorText: "Username tidak valid",
                )
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: "email",
              label: "Email",
              hintText: "Masukkan email kamu",
              initialValue: user.email,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
                FormBuilderValidators.email(
                  errorText: "Email tidak valid",
                )
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: "dateOfBirth",
              label: "Tanggal Lahir",
              hintText: "dd/mm/yyyy",
              initialValue: user.dateOfBirth,
              hasPrefixIcon: false,
              suffixIconName: "calendar.svg",
              textInputType: TextInputType.none,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
              onTap: showBirthDatePicker,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              isSmall: true,
              name: "phoneNumber",
              label: "No. HP",
              hintText: "Masukkan nomor hp kamu",
              initialValue: user.phone,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
                FormBuilderValidators.integer(
                  errorText: 'No. HP tidak valid',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showBirthDatePicker() async {
    final dateOfBirth = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 30),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Lahir',
      locale: const Locale('id', 'ID'),
    );

    if (dateOfBirth != null) {
      date = dateOfBirth;

      final value = '${date.day}/${date.month}/${date.year}';

      formKey.currentState!.fields['dateOfBirth']!.didChange(value);
    }
  }

  void editProfile() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      // final data = formKey.currentState!.value;

      navigatorKey.currentState!.pop(true);
    }
  }
}
