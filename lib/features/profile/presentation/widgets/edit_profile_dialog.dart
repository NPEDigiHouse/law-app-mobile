// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:law_app/features/shared/models/user_model.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class EditProfileDialog extends StatefulWidget {
  final UserModel user;

  const EditProfileDialog({super.key, required this.user});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final formKey = GlobalKey<FormBuilderState>();

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return CustomDialog(
          title: 'Edit Profil',
          onPressedPrimaryButton: () => editProfile(ref),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  isSmall: true,
                  name: "name",
                  label: "Nama Lengkap",
                  hintText: "Masukkan nama lengkap kamu",
                  initialValue: widget.user.name,
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
                  name: "email",
                  label: "Email",
                  hintText: "Masukkan email kamu",
                  initialValue: widget.user.email,
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
                  name: "birthDate",
                  label: "Tanggal Lahir",
                  hintText: "dd MMMM yyyy",
                  initialValue:
                      widget.user.birthDate?.toStringPattern('dd MMMM yyyy'),
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
                  hintText: "+62xxx",
                  initialValue: widget.user.phoneNumber,
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
      },
    );
  }

  Future<void> showBirthDatePicker() async {
    final birthDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 30),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Lahir',
      locale: const Locale('id', 'ID'),
    );

    if (birthDate != null) {
      date = birthDate;

      final value = date.toStringPattern('dd MMMM yyyy');

      formKey.currentState!.fields['birthDate']!.didChange(value);
    }
  }

  void editProfile(WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(editProfileProvider.notifier).editProfile(
            user: widget.user.copyWith(
              name: data['name'],
              email: data['email'],
              birthDate: date,
              phoneNumber: data['phoneNumber'],
            ),
          );

      navigatorKey.currentState!.pop();
    }
  }
}
