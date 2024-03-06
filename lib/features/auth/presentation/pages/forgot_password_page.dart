// Dart imports:
import 'dart:async';
import 'dart:math' as math;

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
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/presentation/pages/otp_page.dart';
import 'package:law_app/features/auth/presentation/providers/ask_reset_password_provider.dart';
import 'package:law_app/features/auth/presentation/widgets/secondary_header.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ForgotpasswordPage extends ConsumerStatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  ConsumerState<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends ConsumerState<ForgotpasswordPage>
    with AfterLayoutMixin<ForgotpasswordPage> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(askResetPasswordProvider, (_, state) {
      state.when(
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
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pushNamed(
              otpRoute,
              arguments: OtpPageArgs(
                email: formKey.currentState!.value['email'],
                otp: data,
              ),
            );
          }
        },
      );
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.back();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SecondaryHeader(
                withBackButton: true,
              ),
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
                        assetPath: AssetPath.getVector('lock.svg'),
                        width: 250,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Lupa\nPassword?',
                      style: textTheme.displaySmall!.copyWith(
                        color: primaryColor,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kami akan mengirimkan Kode OTP ke email yang Anda masukkan di bawah.',
                      style: textTheme.bodyMedium!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FormBuilder(
                      key: formKey,
                      child: CustomTextField(
                        name: 'email',
                        label: 'Email',
                        hintText: 'Masukkan email kamu',
                        prefixIconName: 'envelope-solid.svg',
                        hasSuffixIcon: false,
                        textInputType: TextInputType.emailAddress,
                        validators: [
                          FormBuilderValidators.required(
                            errorText: 'Bagian ini harus diisi',
                          ),
                          FormBuilderValidators.email(
                            errorText: 'Email tidak valid',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: sendOtpCode,
                      label: const Text('Kirim OTP Kode'),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Transform.rotate(
                          angle: -45 * math.pi / 180,
                          child: SvgAsset(
                            assetPath: AssetPath.getIcon('send-filled.svg'),
                            color: secondaryColor,
                          ),
                        ),
                      ),
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

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    scaffoldMessengerKey.currentState!.hideCurrentMaterialBanner();
  }

  void sendOtpCode() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      String email = formKey.currentState!.value['email'];

      ref
          .read(askResetPasswordProvider.notifier)
          .askResetPassword(email: email);
    }
  }
}
