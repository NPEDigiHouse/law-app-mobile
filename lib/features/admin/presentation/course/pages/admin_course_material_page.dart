// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/enums/course_material_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_article_form_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_quiz_form_page.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_material_card.dart';
import 'package:law_app/features/shared/providers/course_providers/article_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/course_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/curriculum_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_actions_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseMaterialPage extends ConsumerWidget {
  final int curriculumId;

  const AdminCourseMaterialPage({super.key, required this.curriculumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(CurriculumDetailProvider(id: curriculumId));

    ref.watch(articlesProvider);
    ref.watch(quizesProvider);

    ref.listen(CurriculumDetailProvider(id: curriculumId), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(curriculumDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (curriculum) {
          if (curriculum != null) {
            ref.read(articlesProvider.notifier).state = curriculum.articles!;
            ref.read(quizesProvider.notifier).state = curriculum.quizzes!;
          }
        },
      );
    });

    ref.listen(articleActionsProvider, (_, state) {
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

            ref.invalidate(curriculumDetailProvider);
            ref.invalidate(courseDetailProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    ref.listen(quizActionsProvider, (_, state) {
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

            ref.invalidate(curriculumDetailProvider);
            ref.invalidate(courseDetailProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Materi',
          withBackButton: true,
        ),
      ),
      body: curriculum.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (curriculum) {
          if (curriculum == null) return null;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${curriculum.title}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: primaryColor,
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
                        'Total durasi materi sekitar ${curriculum.curriculumDuration} menit',
                        style: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (curriculum.articles!.isEmpty && curriculum.quizzes!.isEmpty)
                  const EmptyContentText('Belum ada materi pada kurikulum ini!')
                else ...[
                  ...List<Padding>.generate(
                    curriculum.articles!.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            index == curriculum.articles!.length - 1 ? 0 : 8,
                      ),
                      child: AdminMaterialCard(
                        material: curriculum.articles![index],
                        type: CourseMaterialType.article,
                      ),
                    ),
                  ),
                  if (curriculum.articles!.isNotEmpty)
                    const SizedBox(height: 8),
                  ...List<Padding>.generate(
                    curriculum.quizzes!.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == curriculum.quizzes!.length - 1 ? 0 : 8,
                      ),
                      child: AdminMaterialCard(
                        material: curriculum.quizzes![index],
                        type: CourseMaterialType.quiz,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => context.showCustomSelectorDialog(
                    title: "Pilih Jenis Materi",
                    items: [
                      {
                        "text": "Artikel",
                        "onTap": () {
                          navigatorKey.currentState!.pop();
                          navigatorKey.currentState!.pushNamed(
                            adminCourseArticleFormRoute,
                            arguments: AdminCourseArticleFormPageArgs(
                              title: 'Tambah Artikel',
                              curriculumId: curriculumId,
                            ),
                          );
                        },
                      },
                      {
                        "text": "Quiz",
                        "onTap": () {
                          navigatorKey.currentState!.pop();
                          navigatorKey.currentState!.pushNamed(
                            adminCourseQuizFormRoute,
                            arguments: AdminCourseQuizFormPageArgs(
                              title: 'Tambah Quiz',
                              curriculumId: curriculumId,
                            ),
                          );
                        },
                      }
                    ],
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah Materi'),
                ).fullWidth(),
              ],
            ),
          );
        },
      ),
    );
  }
}
