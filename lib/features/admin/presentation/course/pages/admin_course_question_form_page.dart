// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';

class AdminCourseQuestionFormPage extends ConsumerStatefulWidget {
  final String title;
  final QuestionModel? question;

  const AdminCourseQuestionFormPage({
    super.key,
    required this.title,
    this.question,
  });

  @override
  ConsumerState<AdminCourseQuestionFormPage> createState() =>
      _AdminCourseQuestionFormPageState();
}

class _AdminCourseQuestionFormPageState
    extends ConsumerState<AdminCourseQuestionFormPage> {
  late final ValueNotifier<int?> correctOptionId;

  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      correctOptionId = ValueNotifier(widget.question!.correctOptionId);
    } else {
      correctOptionId = ValueNotifier(null);
    }
  }

  @override
  void dispose() {
    super.dispose();

    correctOptionId.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
    //   return Scaffold(
    //     appBar: PreferredSize(
    //       preferredSize: const Size.fromHeight(96),
    //       child: HeaderContainer(
    //         title: widget.isEdit ? "Edit Soal" : 'Tambah Soal',
    //         withBackButton: true,
    //       ),
    //     ),
    //     body: SingleChildScrollView(
    //       padding: const EdgeInsets.all(20),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           CustomTextField(
    //             name: "question_description",
    //             label: "Deskripsi Soal",
    //             hintText: "Masukkan soal",
    //             initialValue: widget.item != null ? widget.item!.question : "",
    //             hasPrefixIcon: false,
    //             hasSuffixIcon: false,
    //             textInputAction: TextInputAction.done,
    //             validators: [
    //               FormBuilderValidators.required(
    //                 errorText: "Bagian ini harus diisi",
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 24),
    //           Text(
    //             "Pilihan Jawaban",
    //             style: textTheme.titleSmall!,
    //           ),
    //           const SizedBox(height: 8),
    //           if (widget.item != null)
    //             ...List<InkWellContainer>.generate(
    //               widget.item!.answers.length,
    //               (index) => InkWellContainer(
    //                 width: double.infinity,
    //                 margin: const EdgeInsets.only(bottom: 8),
    //                 color: scaffoldBackgroundColor,
    //                 radius: 12,
    //                 onTap: () => context.showSingleFormDialog(
    //                   title: "Edit Jawaban",
    //                   name: "answer",
    //                   label: "Jawaban",
    //                   hintText: "Masukkan jawaban",
    //                   initialValue: widget.item!.answers.values.toList()[index],
    //                 ),
    //                 padding: const EdgeInsets.symmetric(
    //                   vertical: 20,
    //                   horizontal: 16,
    //                 ),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.black.withOpacity(.2),
    //                     offset: const Offset(2, 2),
    //                     blurRadius: 4,
    //                   ),
    //                 ],
    //                 child: Text(
    //                   "${widget.item!.answers.keys.toList()[index]}. ${widget.item!.answers.values.toList()[index]}",
    //                   style: textTheme.bodyLarge!,
    //                 ),
    //               ),
    //             )
    //           else
    //             Text(
    //               "Belum Ada Jawaban",
    //               style:
    //                   textTheme.bodyMedium!.copyWith(color: secondaryTextColor),
    //             ),
    //           const SizedBox(height: 8),
    //           FilledButton(
    //             onPressed: () => context.showSingleFormDialog(
    //               title: "Tambah Jawaban",
    //               name: "answer",
    //               label: "Jawaban",
    //               hintText: "Masukkan jawaban",
    //             ),
    //             child: const Text('Tambah Jawaban'),
    //           ).fullWidth(),
    //           const Divider(
    //             color: secondaryTextColor,
    //             height: 20,
    //           ),
    //           if (widget.item != null) ...[
    //             Text(
    //               "Pilih Jawaban Benar",
    //               style: textTheme.titleSmall!,
    //             ),
    //             Row(
    //               children: [
    //                 ...List<ValueListenableBuilder<String?>>.generate(
    //                   widget.item!.answers.length,
    //                   (index) => ValueListenableBuilder(
    //                     valueListenable: rightAnswer,
    //                     builder: (context, value, child) {
    //                       return Expanded(
    //                         child: Row(
    //                           children: [
    //                             Radio(
    //                               value:
    //                                   widget.item!.answers.keys.toList()[index],
    //                               groupValue: value,
    //                               onChanged: (val) {
    //                                 rightAnswer.value = val!;
    //                               },
    //                             ),
    //                             Text(
    //                               widget.item!.answers.keys.toList()[index],
    //                             ),
    //                           ],
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }
}

class AdminCourseQuestionFormPageArgs {
  final String title;
  final QuestionModel? question;

  const AdminCourseQuestionFormPageArgs({
    required this.title,
    this.question,
  });
}
