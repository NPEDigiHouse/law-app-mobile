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
import 'package:law_app/features/common/auth/widgets/auth_app_bar.dart';
import 'package:law_app/features/common/auth/widgets/custom_text_field.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AuthAppBar(
        onPressedBackButton: () => navigatorKey.currentState!.pop(),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgAsset(
                  assetPath: AssetPath.getVector('lock_illustration.svg'),
                  width: 250,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Lupa\nPassword?',
                style: textTheme.displaySmall!.copyWith(
                  color: primaryColor,
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
                child: Column(
                  children: [
                    CustomTextField(
                      name: 'email',
                      label: 'Email',
                      hintText: 'Masukkan email terdaftar',
                      prefixIconName: 'envelope-solid.svg',
                      hasSuffixIcon: false,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: 'Bagian ini harus diisi',
                        ),
                        FormBuilderValidators.email(
                          errorText: 'Email tidak valid',
                        ),
                      ],
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

  void sendOtpCode(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      // final phoneNumber = formKey.currentState!.value['phone_number'] as String;

      // show loading indicator
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const LoadingIndicator(),
      // );
    }
  }
}