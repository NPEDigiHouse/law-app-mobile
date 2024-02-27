import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_text_field.dart';

class AdminCourseAddArticlePage extends StatefulWidget {
  const AdminCourseAddArticlePage({super.key});

  @override
  State<AdminCourseAddArticlePage> createState() =>
      _AdminCourseAddArticlePageState();
}

class _AdminCourseAddArticlePageState extends State<AdminCourseAddArticlePage> {

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
                      textInputType: TextInputType.text,
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
                      label: "Perkiraan Durasi Belajar",
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
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Konten",
                textAlign: TextAlign.left,
                style: textTheme.titleSmall!,
              ),
              const SizedBox(
                height: 24,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
