// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/checkbox_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/form_field/markdown_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuizFormPage extends ConsumerStatefulWidget {
  final String title;
  final int? curriculumId;
  final QuizModel? quiz;

  const AdminCourseQuizFormPage({
    super.key,
    required this.title,
    this.curriculumId,
    this.quiz,
  });

  @override
  ConsumerState<AdminCourseQuizFormPage> createState() =>
      _AdminCourseQuizFormPageState();
}

class _AdminCourseQuizFormPageState
    extends ConsumerState<AdminCourseQuizFormPage> with AfterLayoutMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (widget.quiz != null) {
      context.showLoadingDialog();

      ref.read(titleProvider.notifier).state = widget.quiz!.title!;
      ref.read(durationProvider.notifier).state =
          widget.quiz!.duration!.toString();
      ref.read(materialProvider.notifier).state = widget.quiz!.description!;

      navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showPreview = ref.watch(isCheckedProvider);
    final title = ref.watch(titleProvider);
    final duration = ref.watch(durationProvider);
    final description = ref.watch(materialProvider);

    ref.listen(quizActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();

            if (widget.quiz != null) {
              ref.invalidate(QuizDetailProvider(id: widget.quiz!.id!));
            }
          }
        },
      );
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: showPreview ? 'Preview Quiz' : widget.title,
          withBackButton: !showPreview,
          withTrailingButton: !showPreview,
          trailingButtonIconName: 'check-line.svg',
          trailingButtonTooltip: 'Submit',
          onPressedTrailingButton: () {
            widget.quiz != null ? editQuiz() : createQuiz();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: showPreview
            ? buildQuizPreview(title, duration, description)
            : buildQuizForm(title, duration, description),
      ),
      floatingActionButton: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: GradientColors.redPastel,
          ),
        ),
        child: IconButton(
          onPressed: () {
            if (!showPreview) {
              ref.read(titleProvider.notifier).state =
                  formKey.currentState!.fields['title']!.value;
              ref.read(durationProvider.notifier).state =
                  formKey.currentState!.fields['duration']!.value;
              ref.read(materialProvider.notifier).state =
                  formKey.currentState!.fields['description']!.value;
            }

            ref.read(isCheckedProvider.notifier).state = !showPreview;
          },
          icon: showPreview
              ? const Icon(
                  Icons.visibility_outlined,
                  color: scaffoldBackgroundColor,
                )
              : const Icon(
                  Icons.code_outlined,
                  color: scaffoldBackgroundColor,
                ),
          tooltip: showPreview ? 'Preview' : 'Editor',
        ),
      ),
    );
  }

  Column buildQuizPreview(
    String? title,
    String? duration,
    String? description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgAsset(
          assetPath: AssetPath.getIcon('note-edit-line.svg'),
          color: primaryColor,
          width: 50,
        ),
        const SizedBox(height: 8),
        Text(
          title ?? '',
          style: textTheme.headlineSmall!.copyWith(
            color: primaryColor,
            height: 0,
          ),
        ),
        const SizedBox(height: 12),
        MarkdownBody(
          data: description ?? '',
          selectable: true,
          onTapLink: (text, href, title) async {
            if (href != null) {
              final url = Uri.parse(href);

              if (await canLaunchUrl(url)) await launchUrl(url);
            }
          },
        ),
        const SizedBox(height: 16),
        buildQuizInfoText(
          title: 'Total Soal',
          value: '${widget.quiz?.totalQuestions ?? 0} soal',
        ),
        buildQuizInfoText(
          title: 'Waktu Pengerjaan',
          value: '${duration ?? ''} menit',
        ),
      ],
    );
  }

  Padding buildQuizInfoText({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.titleSmall!.copyWith(
                color: valueColor ?? primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  FormBuilder buildQuizForm(
    String? title,
    String? duration,
    String? description,
  ) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            name: 'title',
            label: 'Judul',
            hintText: 'Masukkan judul quiz',
            initialValue: title ?? widget.quiz?.title,
            hasPrefixIcon: false,
            hasSuffixIcon: false,
            textCapitalization: TextCapitalization.words,
            validators: [
              FormBuilderValidators.required(
                errorText: "Bagian ini harus diisi",
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            name: 'duration',
            label: 'Durasi (Menit)',
            hintText: 'Masukkan durasi pengerjaan',
            initialValue: duration ?? widget.quiz?.duration.toString(),
            hasPrefixIcon: false,
            hasSuffixIcon: false,
            textInputType: TextInputType.number,
            validators: [
              FormBuilderValidators.required(
                errorText: "Bagian ini harus diisi",
              ),
              FormBuilderValidators.integer(
                errorText: "Inputan harus berupa bilangan bulat",
              ),
              FormBuilderValidators.min(
                1,
                errorText: "Durasi minimal adalah 1 menit",
              ),
            ],
          ),
          const SizedBox(height: 20),
          MarkdownField(
            name: 'description',
            label: 'Deskripsi',
            hintText: 'Masukkan deskripsi quiz',
            initialValue: description ?? widget.quiz?.description,
            onChanged: (_) {},
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  void editQuiz() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(quizActionsProvider.notifier).editQuiz(
            quiz: widget.quiz!.copyWith(
              title: data['title'],
              duration: int.tryParse(data['duration']),
              description: data['description'],
            ),
          );
    } else {
      context.showBanner(
        message: 'Masih terdapat form yang kosong!',
        type: BannerType.error,
      );
    }
  }

  void createQuiz() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(quizActionsProvider.notifier).createQuiz(
            quiz: QuizPostModel(
              title: data['title'],
              duration: int.tryParse(data['duration']) ?? 0,
              description: data['description'],
              curriculumId: widget.curriculumId!,
            ),
          );
    } else {
      context.showBanner(
        message: 'Masih terdapat form yang kosong!',
        type: BannerType.error,
      );
    }
  }
}

class AdminCourseQuizFormPageArgs {
  final String title;
  final int? curriculumId;
  final QuizModel? quiz;

  const AdminCourseQuizFormPageArgs({
    required this.title,
    this.curriculumId,
    this.quiz,
  });
}
