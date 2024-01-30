import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
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
            ),
            const SizedBox(height: 12),
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
                      child: const Text('Kembali'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: changePassword,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Text('Konfirmasi'),
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

  void changePassword() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      debugPrint(data.toString());

      navigatorKey.currentState!.pop(true);
    }
  }
}
