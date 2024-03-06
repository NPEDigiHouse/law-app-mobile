// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AdminCourseAddQuizPage extends StatelessWidget {
  const AdminCourseAddQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Tambah Quiz',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilder(
                child: Column(
                  children: [
                    CustomTextField(
                      name: "article_title",
                      label: "Judul Materi",
                      hintText: "Masukkan judul",
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Bagian ini harus diisi",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      name: "completion_time",
                      label: "Waktu Pengerjaan",
                      hintText: "Masukkan waktu (menit)",
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      textInputType: TextInputType.number,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Bagian ini harus diisi",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      name: "quiz_description",
                      label: "Deskripsi Quiz",
                      hintText: "Masukkan waktu (menit)",
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: "Bagian ini harus diisi",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Tambah Quiz'),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }
}
