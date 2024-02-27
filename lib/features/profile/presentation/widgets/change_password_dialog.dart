// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/profile/presentation/providers/change_password_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/form_field/password_text_field.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  late final ValueNotifier<String> password;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    password = ValueNotifier('');
  }

  @override
  void dispose() {
    super.dispose();

    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Ganti Password',
      onPressedPrimaryButton: changePassword,
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            PasswordTextField(
              isSmall: true,
              name: 'currentPassword',
              label: 'Password Lama',
              hintText: 'Masukkan password lama',
              hasPrefixIcon: false,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Bagian ini harus diisi',
                ),
              ],
            ),
            const SizedBox(height: 10),
            PasswordTextField(
              isSmall: true,
              name: 'newPassword',
              label: 'Password Baru',
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
                  errorText: 'Password minimal 8 karakter',
                ),
              ],
              onChanged: (value) {
                if (value != null) password.value = value;
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: password,
              builder: (context, password, child) {
                return PasswordTextField(
                  isSmall: true,
                  name: 'confirmNewPassword',
                  label: 'Konfirmasi Password Baru',
                  hintText: 'Ulangi password sebelumnya',
                  hasPrefixIcon: false,
                  textInputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Bagian ini harus diisi',
                    ),
                    FormBuilderValidators.equal(
                      password,
                      errorText: 'Konfirmasi password baru salah',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void changePassword() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(changePasswordProvider.notifier).changePassword(
            email: CredentialSaver.user!.email!,
            currentPassword: data['currentPassword'],
            newPassword: data['newPassword'],
          );

      navigatorKey.currentState!.pop();
    }
  }
}
