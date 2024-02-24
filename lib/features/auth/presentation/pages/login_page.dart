// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/presentation/providers/sign_in_provider.dart';
import 'package:law_app/features/auth/presentation/widgets/primary_header.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/text_field/password_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  final Map<String, Object>? bannerData;

  const LoginPage({super.key, this.bannerData});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(
      signInProvider,
      (_, state) {
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
            if (data.$1 != null && data.$2 != null) {
              debugPrint(data.$2!.role);
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                // TODO : Change back to 'admin'
                data.$2!.role == 'student' ? adminHomeRoute : mainMenuRoute,
                (route) => false,
                arguments: data.$2,
              );
            }
          },
        );
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PrimaryHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: textTheme.headlineMedium!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    'Silahkan login untuk melanjutkan',
                    style: textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilder(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextField(
                          name: 'username',
                          label: 'Username',
                          hintText: 'Masukkan username kamu',
                          prefixIconName: 'user-solid.svg',
                          hasSuffixIcon: false,
                          validators: [
                            FormBuilderValidators.required(
                              errorText: 'Bagian ini harus diisi',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        PasswordTextField(
                          name: 'password',
                          label: 'Password',
                          hintText: 'Masukkan password kamu',
                          prefixIconName: 'lock-solid.svg',
                          textInputType: TextInputType.visiblePassword,
                          validators: [
                            FormBuilderValidators.required(
                              errorText: 'Bagian ini harus diisi',
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            forgotPasswordRoute,
                          ),
                          child: Text(
                            'Lupa Password?',
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: login,
                    child: const Text('Login'),
                  ).fullWidth(),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text('Belum punya akun? Buat akun baru\t'),
                      ),
                      GestureDetector(
                        onTap: () => navigatorKey.currentState!.pushNamed(
                          registerRoute,
                        ),
                        child: Text(
                          'di sini',
                          style: textTheme.titleSmall!.copyWith(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (widget.bannerData != null) {
      context.showBanner(
        message: widget.bannerData!['message'] as String,
        type: widget.bannerData!['bannerType'] as BannerType,
      );
    }
  }

  void login() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(signInProvider.notifier).signIn(
            username: data['username'],
            password: data['password'],
          );
    }
  }
}
