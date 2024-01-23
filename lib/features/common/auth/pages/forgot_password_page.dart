import 'dart:async';
import 'dart:math' as math;
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/common/auth/widgets/custom_text_field.dart';
import 'package:law_app/features/common/auth/widgets/secondary_header.dart';
import 'package:law_app/features/common/shared/banner_type.dart';
import 'package:law_app/features/common/shared/svg_asset.dart';

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage>
    with AfterLayoutMixin<ForgotpasswordPage> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => sendOtpCode(context),
                      label: const Text('Kirim OTP Kode'),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Transform.rotate(
                          angle: -45 * math.pi / 180,
                          child: SvgAsset(
                            assetPath: AssetPath.getIcon(
                              'carbon-send-filled.svg',
                            ),
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

  Future<void> sendOtpCode(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final email = formKey.currentState!.value['email'] as String;

      if (email != user.email) {
        final errorBanner = WidgetUtils.createMaterialBanner(
          content: 'Email tidak terdaftar!',
          type: BannerType.error,
        );

        // Show material banner
        scaffoldMessengerKey.currentState!
          ..hideCurrentMaterialBanner()
          ..showMaterialBanner(errorBanner);
      } else {
        // Show loading indicator
        context.showLoadingDialog();

        // Proccess...
        await Future.delayed(const Duration(seconds: 3));

        // Close loading indicator
        navigatorKey.currentState!.pop();

        // Navigate to otp page if success
        navigatorKey.currentState!.pushReplacementNamed(
          otpRoute,
          arguments: email,
        );
      }
    }
  }
}