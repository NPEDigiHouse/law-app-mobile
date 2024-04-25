// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/option_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_option_card.dart';
import 'package:law_app/features/shared/providers/course_providers/option_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/question_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/question_detail_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class AdminCourseQuestionFormPage extends ConsumerStatefulWidget {
  final int id;
  final int number;

  const AdminCourseQuestionFormPage({
    super.key,
    required this.id,
    required this.number,
  });

  @override
  ConsumerState<AdminCourseQuestionFormPage> createState() => _AdminCourseQuestionFormPageState();
}

class _AdminCourseQuestionFormPageState extends ConsumerState<AdminCourseQuestionFormPage> {
  late final GlobalKey<FormBuilderState> formKey;
  late final ValueNotifier<int?> correctOptionId;
  late final ValueNotifier<String?> questionTitle;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormBuilderState>();
    correctOptionId = ValueNotifier(null);
    questionTitle = ValueNotifier(null);
  }

  @override
  void dispose() {
    super.dispose();

    correctOptionId.dispose();
    questionTitle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(QuestionDetailProvider(id: widget.id));

    ref.listen(QuestionDetailProvider(id: widget.id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(questionDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(questionActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();
            ref.invalidate(questionDetailProvider);
          }
        },
      );
    });

    ref.listen(optionActionsProvider, (_, state) {
      questionTitle.value = formKey.currentState!.fields['title']!.value;

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
            navigatorKey.currentState!.pop();
            ref.invalidate(questionDetailProvider);
          }
        },
      );
    });

    return data.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (data) {
        final question = data.question;
        final options = data.options;

        if (question == null || options == null) return const Scaffold();

        correctOptionId.value ??= question.correctOptionId;
        questionTitle.value ??= question.title;

        final optionKeys = ['A', 'B', 'C', 'D'];

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Edit Pertanyaan',
              withBackButton: true,
              withTrailingButton: true,
              trailingButtonIconName: 'check-line.svg',
              trailingButtonTooltip: 'Edit',
              onPressedTrailingButton: () => editQuestion(question),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilder(
                  key: formKey,
                  child: ValueListenableBuilder(
                    valueListenable: questionTitle,
                    builder: (context, value, child) {
                      return CustomTextField(
                        name: 'title',
                        label: 'Pertanyaan',
                        hintText: 'Masukkan pertanyaan',
                        initialValue: value,
                        maxLines: 5,
                        hasPrefixIcon: false,
                        hasSuffixIcon: false,
                        textInputAction: TextInputAction.newline,
                        validators: [
                          FormBuilderValidators.required(
                            errorText: "Bagian ini harus diisi",
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (options.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ...List<Padding>.generate(
                    options.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == options.length - 1 ? 0 : 8,
                      ),
                      child: AdminOptionCard(
                        optionKey: optionKeys[index],
                        option: options[index],
                      ),
                    ),
                  ),
                ],
                if (options.length < 4) ...[
                  SizedBox(
                    height: options.isEmpty ? 16 : 10,
                  ),
                  FilledButton.icon(
                    onPressed: () => context.showSingleFormDialog(
                      title: 'Tambah Jawaban',
                      name: 'title',
                      label: 'Jawaban',
                      hintText: 'Masukkan jawaban',
                      maxLines: 5,
                      primaryButtonText: 'Tambah',
                      onSubmitted: (value) {
                        navigatorKey.currentState!.pop();

                        ref.read(optionActionsProvider.notifier).createOption(
                              option: OptionPostModel(
                                title: value['title'],
                                quizQuestionId: widget.id,
                              ),
                            );
                      },
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Tambah Jawaban'),
                  ).fullWidth(),
                ],
                if (options.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      bottom: 12,
                    ),
                    child: Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Text(
                    'Pilih Jawaban Benar',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ValueListenableBuilder(
                    valueListenable: correctOptionId,
                    builder: (context, value, child) {
                      return Row(
                        children: List<Expanded>.generate(
                          options.length,
                          (index) => Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<int>(
                                  value: options[index].id!,
                                  groupValue: value,
                                  onChanged: (value) {
                                    correctOptionId.value = value;
                                  },
                                  visualDensity: const VisualDensity(
                                    vertical: VisualDensity.minimumDensity,
                                    horizontal: VisualDensity.minimumDensity,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  optionKeys[index],
                                  style: textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void editQuestion(QuestionModel question) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (correctOptionId.value == null) {
        context.showCustomInformationDialog(
          title: 'Gagal mengedit pertanyaan!',
          child: const Text('Harap pilih terlebih dahulu opsi jawaban yang benar.'),
        );

        return;
      }

      ref.read(questionActionsProvider.notifier).editQuestion(
            question: question.copyWith(
              title: formKey.currentState!.value['title'],
              correctOptionId: correctOptionId.value,
            ),
          );
    }
  }
}

class AdminCourseQuestionFormPageArgs {
  final int id;
  final int number;

  const AdminCourseQuestionFormPageArgs({
    required this.id,
    required this.number,
  });
}
