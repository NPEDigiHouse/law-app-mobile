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
import 'package:law_app/features/common/widgets/custom_text_field.dart';
import 'package:law_app/features/common/widgets/password_text_field.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';
import 'package:law_app/features/dummies_data.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 285,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: GradientColors.redPastel,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -20,
                    right: 20,
                    child: SvgAsset(
                      assetPath: AssetPath.getVector('app_logo_white.svg'),
                      color: tertiaryColor,
                      width: 160,
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgAsset(
                          assetPath: AssetPath.getVector('app_logo_white.svg'),
                          width: 80,
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: textTheme.headlineMedium,
                            children: const [
                              TextSpan(
                                text: 'Selamat Datang,\n',
                                style: TextStyle(
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              TextSpan(
                                text: 'Sobat Hukum!',
                                style: TextStyle(
                                  color: accentTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                    'Silahkan Login untuk melanjutkan',
                    style: textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextField(
                          name: 'username',
                          label: 'Username',
                          hintText: 'Masukkan username Anda',
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
                          hintText: 'Masukkan password Anda',
                          textInputType: TextInputType.visiblePassword,
                          prefixIconName: 'lock-solid.svg',
                          validators: [
                            FormBuilderValidators.required(
                              errorText: 'Bagian ini harus diisi',
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            forgotPasswordRoute,
                          ),
                          child: Text(
                            'Lupa Password?',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: () => login(context),
                          child: const Text('Login'),
                        ).fullWidth(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Belum punya akun? Buat akun baru\t'),
                      GestureDetector(
                        onTap: () => navigatorKey.currentState!.pushNamed(
                          registerRoute,
                        ),
                        child: Text(
                          'di sini.',
                          style: textTheme.titleSmall?.copyWith(
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

  void login(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;

      if (data['username'] != user.username ||
          data['password'] != user.password) {
        final errorBanner = WidgetUtils.createMaterialBanner(
          contentText: 'Username atau Password salah!',
          leadingIconName: 'times-circle-line.svg',
          foregroundColor: scaffoldBackgroundColor,
          backgroundColor: errorColor,
        );

        // Show material banner
        scaffoldMessengerKey.currentState!
          ..hideCurrentMaterialBanner()
          ..showMaterialBanner(errorBanner);
      } else {
        // Navigate to student home page
        navigatorKey.currentState!.pushReplacementNamed(studentHomeRoute);
      }
    }
  }
}
