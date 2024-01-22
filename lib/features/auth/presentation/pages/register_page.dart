import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/app_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:law_app/features/auth/presentation/widgets/password_text_field.dart';
import 'package:law_app/features/auth/presentation/widgets/primary_header.dart';
import 'package:law_app/features/common/shared/banner_type.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with AfterLayoutMixin<RegisterPage> {
  late final ValueNotifier<String> passwordNotifier;

  final formKey = GlobalKey<FormBuilderState>();

  var date = DateTime.now();

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

        context.back();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const PrimaryHeader(
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
                    Text(
                      'Buat Akun',
                      style: textTheme.headlineMedium!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Daftarkan akun Anda untuk belajar Hukum dengan cara yang menyenangkan!',
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
                            name: 'name',
                            label: 'Nama Lengkap',
                            hintText: 'Masukkan nama lengkap kamu',
                            hasPrefixIcon: false,
                            hasSuffixIcon: false,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                              FormBuilderValidators.match(
                                r'^[a-zA-Z\s]*$',
                                errorText: 'Nama tidak valid',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            name: 'username',
                            label: 'Username',
                            hintText: 'Masukkan username baru',
                            hasPrefixIcon: false,
                            hasSuffixIcon: false,
                            textInputAction: TextInputAction.next,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                              FormBuilderValidators.match(
                                r'^(?=.*[a-zA-Z])\d*[a-zA-Z\d]*$',
                                errorText: 'Username tidak valid',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            name: 'email',
                            label: 'Email',
                            hintText: 'Masukkan email kamu',
                            hasPrefixIcon: false,
                            hasSuffixIcon: false,
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                              FormBuilderValidators.email(
                                errorText: 'Email tidak valid',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => generateRandomPassword(),
                            child: Text(
                              'Gunakan password acak',
                              style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                          const SizedBox(height: 20),
                          CustomTextField(
                            name: 'date_of_birth',
                            label: 'Tanggal Lahir',
                            hintText: 'dd/mm/yyyy',
                            hasPrefixIcon: false,
                            suffixIconName: 'calendar.svg',
                            textInputType: TextInputType.none,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                            ],
                            onTap: () => showBirthDatePicker(context),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            name: 'phone_number',
                            label: 'No. HP',
                            hintText: '08xxx',
                            hasPrefixIcon: false,
                            hasSuffixIcon: false,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                              FormBuilderValidators.integer(
                                errorText: 'No. HP tidak valid',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        children: const [
                          TextSpan(
                            text: 'Dengan mendaftar, Anda menyetujui\t',
                          ),
                          TextSpan(
                            text: 'Syarat dan Ketentuan\t',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: 'yang berlaku.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: register,
                      child: const Text('Daftarkan Sekarang'),
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

  void generateRandomPassword() {
    final password = AppHelper.generateRandomText();

    formKey.currentState!.fields['password']!.didChange(password);
    formKey.currentState!.fields['confirm_password']!.didChange(password);
  }

  Future<void> showBirthDatePicker(BuildContext context) async {
    final dateOfBirth = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 30),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Lahir',
    );

    if (dateOfBirth != null) {
      date = dateOfBirth;

      final value = '${date.day}/${date.month}/${date.year}';

      formKey.currentState!.fields['date_of_birth']!.didChange(value);
    }
  }

  void register() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      debugPrint(data.toString());

      // Show loading - send data - close loading

      // Navigate back to login page if success, with MaterialBanner as a result.
      navigatorKey.currentState!.pop<MaterialBanner>(
        WidgetUtils.createMaterialBanner(
          message: 'Akun berhasil dibuat. Silahkan login dengan akun tersebut.',
          type: BannerType.success,
        ),
      );
    }
  }
}
