import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/auth/presentation/widgets/password_text_field.dart';
import 'package:law_app/features/auth/presentation/widgets/secondary_header.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final ValueNotifier<String> passwordNotifier;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    passwordNotifier = ValueNotifier('');
  }

  @override
  void dispose() {
    super.dispose();

    passwordNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.showConfirmDialog(
          title: 'Konfirmasi',
          message: 'Anda yakin ingin membatalkan proses ini?',
          onPressedPrimaryButton: () {
            context.back();

            navigatorKey.currentState!.pop();
          },
        );
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SecondaryHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgAsset(
                        assetPath: AssetPath.getVector('unlock.svg'),
                        width: 250,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Buat\nPassword Baru',
                      style: textTheme.displaySmall!.copyWith(
                        color: primaryColor,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingat dengan baik password baru Anda, agar tidak terjadi hal serupa.',
                      style: textTheme.bodyMedium!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                              FormBuilderValidators.maxLength(
                                8,
                                errorText: 'Password minimal 8 huruf',
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) passwordNotifier.value = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder(
                            valueListenable: passwordNotifier,
                            builder: (context, password, child) {
                              return PasswordTextField(
                                name: 'confirm_password',
                                label: 'Konfirmasi Password',
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
                                    errorText: 'Konfirmasi password salah',
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: resetPassword,
                      child: const Text('Konfirmasi'),
                    ).fullWidth(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      debugPrint(data.toString());

      // Show loading - send data - close loading

      // Navigate to login page if success, with banner data
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        loginRoute,
        (route) => false,
        arguments: {
          'message': 'Password Anda berhasil diubah.',
          'banner_type': BannerType.success,
        },
      );
    }
  }
}
