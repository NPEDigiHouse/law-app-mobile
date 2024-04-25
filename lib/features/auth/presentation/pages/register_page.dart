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
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/user_models/user_post_model.dart';
import 'package:law_app/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:law_app/features/auth/presentation/widgets/primary_header.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/form_field/password_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> with AfterLayoutMixin<RegisterPage> {
  late final ValueNotifier<String> password;
  late final GlobalKey<FormBuilderState> formKey;
  late DateTime date;

  @override
  void initState() {
    super.initState();

    password = ValueNotifier('');
    formKey = GlobalKey<FormBuilderState>();
    date = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();

    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signUpProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
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
                            textInputType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
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
                            textCapitalization: TextCapitalization.none,
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
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Bagian ini harus diisi',
                              ),
                              FormBuilderValidators.minLength(
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
                            hintText: 'd MMMM yyyy',
                            hasPrefixIcon: false,
                            suffixIconName: 'calendar.svg',
                            textInputType: TextInputType.none,
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
      firstDate: DateTime(date.year - 50),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Lahir',
      locale: const Locale('id', 'ID'),
    );

    if (birthDate != null) {
      date = birthDate;

      final value = date.toStringPattern('d MMMM yyyy');

      formKey.currentState!.fields['birthDate']!.didChange(value);
    }
  }

  void register() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      final user = UserPostModel(
        name: data['name'],
        username: data['username'],
        email: data['email'],
        password: data['password'],
        birthDate: data['birthDate'] != null
            ? (data['birthDate'] as String).isNotEmpty
                ? date
                : null
            : null,
        phoneNumber: data['phoneNumber'] != null
            ? (data['phoneNumber'] as String).isNotEmpty
                ? data['phoneNumber']
                : null
            : null,
        role: 'student',
        teacherDiscussionCategoryIds: const [],
      );

      ref.read(signUpProvider.notifier).signUp(user: user);
    }
  }
}
