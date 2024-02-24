// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/user_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/get_user_detail_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/master_data_provider.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class MasterDataFormPage extends StatefulWidget {
  final String title;
  final UserModel? user;

  const MasterDataFormPage({
    super.key,
    required this.title,
    this.user,
  });

  @override
  State<MasterDataFormPage> createState() => _MasterDataFormPageState();
}

class _MasterDataFormPageState extends State<MasterDataFormPage> {
  final formKey = GlobalKey<FormBuilderState>();

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: widget.title,
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                name: 'name',
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap',
                initialValue: widget.user?.name,
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
              if (widget.user == null) ...[
                const SizedBox(height: 20),
                CustomTextField(
                  name: 'username',
                  label: 'Username',
                  hintText: 'Masukkan username',
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
              ],
              const SizedBox(height: 20),
              CustomTextField(
                name: 'email',
                label: 'Email',
                hintText: 'Masukkan email',
                initialValue: widget.user?.email,
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
              CustomTextField(
                name: 'birthDate',
                label: 'Tanggal Lahir',
                hintText: 'dd MMMM yyyy',
                initialValue:
                    widget.user?.birthDate?.toStringPattern('dd MMMM yyyy'),
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
                hintText: '+62xxx',
                initialValue: widget.user?.phoneNumber,
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Consumer(
          builder: (context, ref, child) {
            return FilledButton(
              onPressed: () {
                widget.user != null ? editUser(ref) : createUser(ref);
              },
              child: Text('${widget.user != null ? "Edit" : "Tambah"} User'),
            ).fullWidth();
          },
        ),
      ),
    );
  }

  void editUser(WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(masterDataProvider.notifier).editUser(
            id: widget.user!.id!,
            name: data['name'],
            email: data['email'],
            birthDate: date.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
            phoneNumber: data['phoneNumber'],
          );

      ref.invalidate(GetUserDetailProvider(id: widget.user!.id!));

      navigatorKey.currentState!.pop();
    }
  }

  void createUser(WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;
      final role = widget.title.split(' ').last.toLowerCase();

      ref.read(masterDataProvider.notifier).createUser(
            userPostModel: UserPostModel(
              name: data['name'],
              username: data['username'],
              email: data['email'],
              password: data['username'],
              birthDate: date.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
              phoneNumber: data['phoneNumber'],
              role: role,
            ),
          );

      navigatorKey.currentState!.pop();
    }
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
}

class MasterDataFormArgs {
  final String title;
  final UserModel? user;

  const MasterDataFormArgs({
    required this.title,
    this.user,
  });
}
