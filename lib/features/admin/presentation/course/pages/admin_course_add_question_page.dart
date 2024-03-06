// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class AdminCourseAddQuestionPage extends StatefulWidget {
  final Item? item;
  final bool isEdit;
  const AdminCourseAddQuestionPage({
    super.key,
    required this.isEdit,
    this.item,
  });

  @override
  State<AdminCourseAddQuestionPage> createState() =>
      _AdminCourseAddQuestionPageState();
}

class _AdminCourseAddQuestionPageState
    extends State<AdminCourseAddQuestionPage> {
  late final ValueNotifier<String?> rightAnswer;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      rightAnswer = ValueNotifier(widget.item!.rightAnswerOption);
    } else {
      rightAnswer = ValueNotifier(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: widget.isEdit ? "Edit Soal" : 'Tambah Soal',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                name: "question_description",
                label: "Deskripsi Soal",
                hintText: "Masukkan soal",
                initialValue: widget.item != null ? widget.item!.question : "",
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputAction: TextInputAction.done,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Pilihan Jawaban",
                style: textTheme.titleSmall!,
              ),
              const SizedBox(
                height: 8,
              ),
              if (widget.item != null)
                ...List.generate(
                  widget.item!.answers.length,
                  (index) => InkWellContainer(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: scaffoldBackgroundColor,
                    radius: 12,
                    onTap: () => context.showSingleFormDialog(
                      title: "Edit Jawaban",
                      name: "answer",
                      label: "Jawaban",
                      hintText: "Masukkan jawaban",
                      initialValue: widget.item!.answers.values.toList()[index],
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                    child: Text(
                      "${widget.item!.answers.keys.toList()[index]}. ${widget.item!.answers.values.toList()[index]}",
                      style: textTheme.bodyLarge!,
                    ),
                  ),
                )
              else
                Text(
                  "Belum Ada Jawaban",
                  style:
                      textTheme.bodyMedium!.copyWith(color: secondaryTextColor),
                ),
              const SizedBox(
                height: 8,
              ),
              FilledButton(
                onPressed: () => context.showSingleFormDialog(
                  title: "Tambah Jawaban",
                  name: "answer",
                  label: "Jawaban",
                  hintText: "Masukkan jawaban",
                ),
                child: const Text('Tambah Jawaban'),
              ).fullWidth(),
              const Divider(
                color: secondaryTextColor,
                height: 20,
              ),
              if (widget.item != null) ...[
                Text(
                  "Pilih Jawaban Benar",
                  style: textTheme.titleSmall!,
                ),
                Row(
                  children: [
                    ...List.generate(
                      widget.item!.answers.length,
                      (index) => ValueListenableBuilder(
                        valueListenable: rightAnswer,
                        builder: (context, value, child) {
                          return Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value:
                                      widget.item!.answers.keys.toList()[index],
                                  groupValue: value,
                                  onChanged: (val) {
                                    rightAnswer.value = val!;
                                  },
                                ),
                                Text(
                                  widget.item!.answers.keys.toList()[index],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
