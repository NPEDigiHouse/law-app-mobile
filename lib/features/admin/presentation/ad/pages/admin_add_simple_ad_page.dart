import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class AdminAddSimpleAdPage extends StatelessWidget {
  const AdminAddSimpleAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Tambah Ads Sederhana',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            child: Column(
              children: [
                CustomTextField(
                  name: "title",
                  label: "Judul",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  hintText: "Masukkan judul",
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  name: "description",
                  label: "Deskripsi",
                  maxLines: 4,
                  hintText: "Masukkan deskripsi",
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bagian ini harus diisi")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
