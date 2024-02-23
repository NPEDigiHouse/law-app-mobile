// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class MasterDataFormPage extends StatefulWidget {
  final String title;
  final User? user;

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
                hintText: 'Masukkan nama lengkap kamu',
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
              const SizedBox(height: 20),
              CustomTextField(
                name: 'email',
                label: 'Email',
                hintText: 'Masukkan email kamu',
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
                initialValue: widget.user?.dateOfBirth,
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
        child: FilledButton(
          onPressed: () {},
          child: Text('${widget.user != null ? "Edit" : "Tambah"} User'),
        ).fullWidth(),
      ),
    );
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
  final User? user;

  const MasterDataFormArgs({
    required this.title,
    this.user,
  });
}
