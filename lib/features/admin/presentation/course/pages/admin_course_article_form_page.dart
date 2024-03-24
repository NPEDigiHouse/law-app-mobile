// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/article_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/article_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/article_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/article_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/checkbox_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/form_field/markdown_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AdminCourseArticleFormPage extends ConsumerStatefulWidget {
  final String title;
  final int? curriculumId;
  final ArticleDetailModel? article;

  const AdminCourseArticleFormPage({
    super.key,
    required this.title,
    this.curriculumId,
    this.article,
  });

  @override
  ConsumerState<AdminCourseArticleFormPage> createState() =>
      _AdminCourseArticleFormPageState();
}

class _AdminCourseArticleFormPageState
    extends ConsumerState<AdminCourseArticleFormPage> with AfterLayoutMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (widget.article != null) {
      context.showLoadingDialog();

      ref.read(titleProvider.notifier).state = widget.article!.title!;
      ref.read(durationProvider.notifier).state = widget.article!.duration!;
      ref.read(materialProvider.notifier).state = widget.article!.material!;

      navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showPreview = ref.watch(isCheckedProvider);
    final title = ref.watch(titleProvider);
    final duration = ref.watch(durationProvider);
    final material = ref.watch(materialProvider);

    ref.listen(articleActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();

            if (widget.article != null) {
              ref.invalidate(ArticleDetailProvider(id: widget.article!.id!));
            }
          }
        },
      );
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: widget.title,
          withBackButton: true,
          withTrailingButton: !showPreview,
          trailingButtonIconName: 'check-line.svg',
          trailingButtonTooltip: 'Submit',
          onPressedTrailingButton: () {
            widget.article != null ? editArticle() : createArticle();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: showPreview ? null : buildArticleForm(title, duration, material),
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
                  formKey.currentState!.fields['material']!.value;
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

  FormBuilder buildArticleForm(
    String? title,
    int? duration,
    String? material,
  ) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            name: 'title',
            label: 'Judul Materi',
            hintText: 'Masukkan judul materi',
            initialValue: title ?? widget.article?.title,
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
            label: 'Durasi Belajar (Menit)',
            hintText: 'Masukkan durasi belajar',
            initialValue: duration != null
                ? duration.toString()
                : widget.article?.duration.toString(),
            hasPrefixIcon: false,
            hasSuffixIcon: false,
            textInputType: TextInputType.number,
            validators: [
              FormBuilderValidators.required(
                errorText: "Bagian ini harus diisi",
              ),
              FormBuilderValidators.integer(
                errorText: "Inputan harus berupa angka",
              ),
              FormBuilderValidators.min(
                1,
                errorText: "Durasi minimal adalah 1 menit",
              ),
            ],
          ),
          const SizedBox(height: 20),
          MarkdownField(
            name: 'material',
            label: 'Masukkan Materi',
            hintText: 'Masukkan materi course',
            initialValue: material ?? widget.article?.material,
            onChanged: (_) {},
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  void editArticle() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(articleActionsProvider.notifier).editArticle(
            article: widget.article!.copyWith(
              title: data['title'],
              duration: data['duration'],
              material: data['material'],
            ),
          );
    } else {
      context.showBanner(
        message: 'Masih terdapat form yang kosong!',
        type: BannerType.error,
      );
    }
  }

  void createArticle() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      ref.read(articleActionsProvider.notifier).createArticle(
            article: ArticlePostModel(
              title: data['title'],
              duration: data['duration'],
              material: data['material'],
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

class AdminCourseArticleFormPageArgs {
  final String title;
  final int? curriculumId;
  final ArticleDetailModel? article;

  const AdminCourseArticleFormPageArgs({
    required this.title,
    this.curriculumId,
    this.article,
  });
}
