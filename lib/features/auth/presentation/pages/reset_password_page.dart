// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:law_app/features/auth/presentation/widgets/secondary_header.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/shared/widgets/text_field/password_text_field.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
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
    ref.listen(resetPasswordProvider, (_, state) {
      state.whenOrNull(
        loading: () => context.showLoadingDialog(),
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
              arguments: {
                'message': 'Password Anda berhasil diubah.',
                'bannerType': BannerType.success,
              },
            );
          }
        },
      );
    });

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
                            label: 'Password Baru',
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
                                errorText: 'Password minimal 8 karakter',
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) password.value = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder(
                            valueListenable: password,
                            builder: (context, password, child) {
                              return PasswordTextField(
                                name: 'confirmPassword',
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
      String password = formKey.currentState!.value['password'];

      ref.read(resetPasswordProvider.notifier).resetPassword(
            email: widget.email,
            resetPasswordToken: widget.otp,
            newPassword: password,
          );
    }
  }
}
