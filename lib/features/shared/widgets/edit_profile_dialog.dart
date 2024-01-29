import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

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
    return Dialog(
      elevation: 0,
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                    child: Text(
                      "Ubah Data",
                      style: textTheme.titleLarge!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('close-line.svg'),
                      width: 20,
                    ),
                    tooltip: 'Back',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: FormBuilder(
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
                            errorText: "Bagian ini harus diisi"),
                        FormBuilderValidators.match(
                          r'^[a-zA-Z\s]*$',
                          errorText: "Nama tidak valid",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
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
                            errorText: "Bagian ini harus diisi"),
                        FormBuilderValidators.match(
                          r'^(?=.*[a-zA-Z])\d*[a-zA-Z\d]*$',
                          errorText: "Username tidak valid",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
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
                            errorText: "Bagian ini harus diisi"),
                        FormBuilderValidators.email(
                          errorText: "Email tidak valid",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
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
                            errorText: "Bagian ini harus diisi"),
                      ],
                      onTap: showBirthDatePicker,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    CustomTextField(
                      name: "phone",
                      label: "No. HP",
                      hintText: "Masukkan nomor hp kamu",
                      initialValue: user.phone,
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      textInputType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.none,
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Bagian ini harus diisi"),
                        FormBuilderValidators.integer(
                          errorText: 'No. HP tidak valid',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => navigatorKey.currentState!.pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                      ),
                      child: Text('Kembali'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: editData,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Konfirmasi'),
                    ),
                  ),
                ],
              ),
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
