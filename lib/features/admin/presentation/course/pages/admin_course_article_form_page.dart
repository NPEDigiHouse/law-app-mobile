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
import 'package:law_app/features/admin/data/models/course_models/article_model.dart';
import 'package:law_app/features/admin/data/models/course_models/article_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/article_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/article_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/checkbox_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/form_field/markdown_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseArticleFormPage extends ConsumerStatefulWidget {
  final String title;
  final int? curriculumId;
  final ArticleModel? article;

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
      ref.read(durationProvider.notifier).state =
          widget.article!.duration!.toString();
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
          title: showPreview ? 'Preview Artikel' : widget.title,
          withBackButton: !showPreview,
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
        child: showPreview
            ? buildArticlePreview(title, duration, material)
            : buildArticleForm(title, duration, material),
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

  Column buildArticlePreview(
    String? title,
    String? duration,
    String? material,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgAsset(
          assetPath: AssetPath.getIcon('read-outlined.svg'),
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
        const SizedBox(height: 4),
        Row(
          children: [
            SvgAsset(
              assetPath: AssetPath.getIcon('clock-solid.svg'),
              color: secondaryTextColor,
              width: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${duration ?? ''} menit',
                style: textTheme.bodyMedium!.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        MarkdownBody(
          data: material ?? '',
          selectable: true,
          onTapLink: (text, href, title) async {
            if (href != null) {
              final url = Uri.parse(href);

              if (await canLaunchUrl(url)) await launchUrl(url);
            }
          },
        ),
      ],
    );
  }

  FormBuilder buildArticleForm(
    String? title,
    String? duration,
    String? material,
  ) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            name: 'title',
            label: 'Judul',
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
            label: 'Durasi (Menit)',
            hintText: 'Masukkan durasi belajar',
            initialValue: duration ?? widget.article?.duration.toString(),
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
            name: 'material',
            label: 'Materi',
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
              duration: int.tryParse(data['duration']),
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
              duration: int.tryParse(data['duration']) ?? 0,
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
  final ArticleModel? article;

  const AdminCourseArticleFormPageArgs({
    required this.title,
    this.curriculumId,
    this.article,
  });
}
