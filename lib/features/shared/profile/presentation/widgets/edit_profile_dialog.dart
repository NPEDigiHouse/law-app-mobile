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
      title: 'Ubah Data',
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                name: "name",
                label: "Nama Lengkap",
                hintText: "Masukkan nama lengkap kamu",
                initialValue: user.fullName,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
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
              const SizedBox(height: 12),
              CustomTextField(
                name: "username",
                label: "Username",
                hintText: "Masukkan username kamu",
                initialValue: user.username,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputType: TextInputType.name,
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
              const SizedBox(height: 12),
              CustomTextField(
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
              const SizedBox(height: 12),
              CustomTextField(
                name: "date_of_birth",
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
              const SizedBox(height: 12),
              CustomTextField(
                name: "phone",
                label: "No. HP",
                hintText: "Masukkan nomor hp kamu",
                initialValue: user.phone,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.none,
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
      ],
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
    );

    if (dateOfBirth != null) {
      date = dateOfBirth;

      final value = '${date.day}/${date.month}/${date.year}';

      formKey.currentState!.fields['date_of_birth']!.didChange(value);
    }
  }

  void editData() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      debugPrint(data.toString());

      // Show loading - send data - close loading

      // Navigate back to login page if success, with bool true

      // context.showBanner(
      //   message: "Berhasil Mengubah Data",
      //   type: BannerType.success,
      // );
      navigatorKey.currentState!.pop(true);
    }
  }
}
