import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/password_text_field.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late final ValueNotifier<String> password;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    password = ValueNotifier("");
  }

  @override
  void dispose() {
    super.dispose();

    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Ubah Password',
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              PasswordTextField(
                name: 'password',
                label: 'Password',
                hintText: 'Masukkan password baru',
                hasPrefixIcon: false,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                  FormBuilderValidators.minLength(
                    8,
                    errorText: 'Password minimal 8 huruf',
                  ),
                ],
                onChanged: (value) {
                  if (value != null) password.value = value;
                },
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder(
                valueListenable: password,
                builder: (context, password, child) {
                  return PasswordTextField(
                    name: 'confirm_password',
                    label: 'Konfirmasi Password',
                    hintText: 'Ulangi password sebelumnya',
                    hasPrefixIcon: false,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: 'Bagian ini harus diisi',
                      ),
                      FormBuilderValidators.equal(
                        password,
                        errorText: 'Konfirmasi password salah',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void changePassword() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      // final data = formKey.currentState!.value;

      navigatorKey.currentState!.pop(true);
    }
  }
}
