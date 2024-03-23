// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AdminCourseArticleFormPage extends StatefulWidget {
  const AdminCourseArticleFormPage({super.key});

  @override
  State<AdminCourseArticleFormPage> createState() =>
      _AdminCourseArticleFormPageState();
}

class _AdminCourseArticleFormPageState
    extends State<AdminCourseArticleFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Tambah Materi Biasa',
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: "check-line.svg",
          onPressedTrailingButton: () {},
          trailingButtonTooltip: "Tambah",
        ),
      ),
      body: SingleChildScrollView(
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
                  const SizedBox(height: 24),
                  CustomTextField(
                    name: "completion_time",
                    label: "Perkiraan Durasi Belajar",
                    hintText: "Masukkan waktu (menit)",
                    hasPrefixIcon: false,
                    hasSuffixIcon: false,
                    textInputType: TextInputType.number,
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
            const SizedBox(height: 24),
            Text(
              "Konten",
              textAlign: TextAlign.left,
              style: textTheme.titleSmall!,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
