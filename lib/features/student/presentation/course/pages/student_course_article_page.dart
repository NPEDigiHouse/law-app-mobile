// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/article_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/curriculum_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class StudentCourseArticlePage extends ConsumerStatefulWidget {
  final int id;
  final int userCourseId;
  final int curriculumSequenceNumber;
  final int materialSequenceNumber;
  final int totalMaterials;
  final bool lastCurriculum;

  const StudentCourseArticlePage({
    super.key,
    required this.id,
    required this.userCourseId,
    required this.curriculumSequenceNumber,
    required this.materialSequenceNumber,
    required this.totalMaterials,
    required this.lastCurriculum,
  });

  @override
  ConsumerState<StudentCourseArticlePage> createState() => _StudentCourseArticlePageState();
}

class _StudentCourseArticlePageState extends ConsumerState<StudentCourseArticlePage> with AfterLayoutMixin {
  UserCourseModel? userCourse;

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (widget.userCourseId == 0) return;

    context.showLoadingDialog();

    try {
      userCourse = await ref.watch(UserCourseDetailProvider(id: widget.userCourseId).future);

      if (userCourse != null) {
        if (userCourse!.currentCurriculumSequence! + 1 == widget.curriculumSequenceNumber) {
          if (userCourse!.currentMaterialSequence! + 1 == widget.totalMaterials) {
            updateCurriculumSequence();
          } else if (userCourse!.currentMaterialSequence! + 1 == widget.materialSequenceNumber) {
            updateMaterialSequence();
          }
        }
      }
    } catch (e) {
      debugPrint('$e');
    }

    navigatorKey.currentState!.pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(articlesProvider);
    final ids = articles.map((e) => e.id!).toList();
    final indexId = ids.indexOf(widget.id);

    final article = ref.watch(ArticleDetailProvider(id: widget.id));

    ref.listen(ArticleDetailProvider(id: widget.id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(articleDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(userCourseActionsProvider, (_, state) {
      state.whenOrNull(
        error: (_, __) => navigatorKey.currentState!.pop(),
        data: (data) {
          if (data != null) {
            ref.invalidate(curriculumDetailProvider);
            ref.invalidate(userCourseDetailProvider);
          }
        },
      );
    });

    return article.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (article) {
        if (article == null) return const Scaffold();

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Artikel',
              withBackButton: true,
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
                SvgAsset(
                  assetPath: AssetPath.getIcon('read-outlined.svg'),
                  color: primaryColor,
                  width: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  '${article.title}',
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
                        '${article.duration} menit',
                        style: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MarkdownBody(
                  data: article.material!,
                  selectable: true,
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final url = Uri.parse(href);

                      if (await canLaunchUrl(url)) await launchUrl(url);
                    }
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: ids.length > 1
              ? Container(
                  color: scaffoldBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        color: Theme.of(context).dividerColor,
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (indexId != 0)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: secondaryColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          navigate(
                                            context,
                                            ids[indexId - 1],
                                            widget.materialSequenceNumber - 1,
                                          );
                                        },
                                        icon: SvgAsset(
                                          assetPath: AssetPath.getIcon(
                                            'caret-line-left.svg',
                                          ),
                                          color: primaryColor,
                                          width: 18,
                                        ),
                                        tooltip: 'Sebelumnya',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${articles[indexId - 1].title}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Expanded(
                                child: SizedBox(),
                              ),
                            const SizedBox(width: 10),
                            if (indexId != ids.length - 1)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: secondaryColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          navigate(
                                            context,
                                            ids[indexId + 1],
                                            widget.materialSequenceNumber + 1,
                                          );
                                        },
                                        icon: SvgAsset(
                                          assetPath: AssetPath.getIcon(
                                            'caret-line-right.svg',
                                          ),
                                          color: primaryColor,
                                          width: 18,
                                        ),
                                        tooltip: 'Selanjutnya',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${articles[indexId + 1].title}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Expanded(
                                child: SizedBox(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  void navigate(BuildContext context, int id, int materialSequenceNumber) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => StudentCourseArticlePage(
          id: id,
          userCourseId: widget.userCourseId,
          curriculumSequenceNumber: widget.curriculumSequenceNumber,
          materialSequenceNumber: materialSequenceNumber,
          totalMaterials: widget.totalMaterials,
          lastCurriculum: widget.lastCurriculum,
        ),
        transitionDuration: Duration.zero,
      ),
    );
  }

  void updateMaterialSequence() {
    ref.read(userCourseActionsProvider.notifier).updateUserCourse(
          id: userCourse!.id!,
          currentCurriculumSequence: userCourse!.currentCurriculumSequence!,
          currentMaterialSequence: widget.materialSequenceNumber,
        );
  }

  void updateCurriculumSequence() {
    ref.read(userCourseActionsProvider.notifier).updateUserCourse(
          id: userCourse!.id!,
          currentCurriculumSequence: userCourse!.currentCurriculumSequence! + (widget.lastCurriculum ? 2 : 1),
          currentMaterialSequence: 0,
        );
  }
}

class StudentCourseArticlePageArgs {
  final int id;
  final int userCourseId;
  final int curriculumSequenceNumber;
  final int materialSequenceNumber;
  final int totalMaterials;
  final bool lastCurriculum;

  const StudentCourseArticlePageArgs({
    required this.id,
    required this.userCourseId,
    required this.curriculumSequenceNumber,
    required this.materialSequenceNumber,
    required this.totalMaterials,
    required this.lastCurriculum,
  });
}
