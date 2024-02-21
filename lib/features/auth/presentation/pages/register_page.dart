import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/constants/const.dart';
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/auth/data/models/user_register_model.dart';
import 'package:law_app/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:law_app/features/auth/presentation/widgets/primary_header.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/text_field/password_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with AfterLayoutMixin<RegisterPage> {
  late final ValueNotifier<String> password;

  final formKey = GlobalKey<FormBuilderState>();

  var date = DateTime.now();

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
    ref.listen(
      signUpProvider,
      (_, state) {
        return state.whenOrNull(
          loading: () => context.showLoadingDialog(),
          error: (error, _) {
            navigatorKey.currentState!.pop();

            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  ref.invalidate(signUpProvider);
                },
              );
            } else {
              context.showBanner(
                message: '$error',
                type: BannerType.error,
              );
            }
          },
          data: (data) {
            navigatorKey.currentState!.pop();

            if (data != null) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
                arguments: {
                  'message': 'Akun Anda berhasil dibuat.',
                  'bannerType': BannerType.success,
                },
              );
            }
          },
        );
      },
    );

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
                                errorText: 'Password minimal 8 karakter',
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) password.value = value;
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
                            valueListenable: password,
                            builder: (context, password, child) {
                              return PasswordTextField(
                                name: 'confirmPassword',
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
                            name: 'birthDate',
                            label: 'Tanggal Lahir',
                            hintText: 'dd MMMM yyyy',
                            hasPrefixIcon: false,
                            suffixIconName: 'calendar.svg',
                            textInputType: TextInputType.none,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                            ],
                            onTap: showBirthDatePicker,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            name: 'phoneNumber',
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
                        children: [
                          const TextSpan(
                            text: 'Dengan mendaftar, Anda menyetujui\t',
                          ),
                          TextSpan(
                            text: 'Syarat dan Ketentuan\t',
                            style: textTheme.titleSmall!.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          const TextSpan(
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
    final password = FunctionHelper.generateRandomText();

    formKey.currentState!.fields['password']!.didChange(password);
    formKey.currentState!.fields['confirmPassword']!.didChange(password);
  }

  Future<void> showBirthDatePicker() async {
    final birthDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 30),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Lahir',
      locale: const Locale('id', 'ID'),
    );

    if (birthDate != null) {
      date = birthDate;

      final value = date.toStringPattern('dd MMMM yyyy');

      formKey.currentState!.fields['birthDate']!.didChange(value);
    }
  }

  void register() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      final userSignUpModel = UserSignUpModel(
        name: data['name'],
        username: data['username'],
        email: data['email'],
        password: data['password'],
        birthDate: date.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
        phoneNumber: data['phoneNumber'],
        role: 'student',
      );

      ref
          .read(signUpProvider.notifier)
          .signUp(userSignUpModel: userSignUpModel);
    }
  }
}
