// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class StudentCourseQuizHomePage extends ConsumerWidget {
  final int id;
  final int userCourseId;
  final int curriculumSequenceNumber;
  final int materialSequenceNumber;
  final int totalMaterials;

  const StudentCourseQuizHomePage({
    super.key,
    required this.id,
    required this.userCourseId,
    required this.curriculumSequenceNumber,
    required this.materialSequenceNumber,
    required this.totalMaterials,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizes = ref.watch(quizesProvider);
    final ids = quizes.map((e) => e.id!).toList();
    final indexId = ids.indexOf(id);

    final quiz = ref.watch(QuizDetailProvider(id: id));

    ref.listen(QuizDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(quizDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return quiz.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (quiz) {
        if (quiz == null) return const Scaffold();

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Beranda Quiz',
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
                  assetPath: AssetPath.getIcon('note-edit-line.svg'),
                  color: primaryColor,
                  width: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  '${quiz.title}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: primaryColor,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 12),
                MarkdownBody(
                  data: quiz.description!,
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
                  value: '${quiz.totalQuestions} soal',
                ),
                buildQuizInfoText(
                  title: 'Waktu Pengerjaan',
                  value: '${quiz.duration} menit',
                ),
                buildQuizInfoText(
                  title: 'Status',
                  value: quiz.answerHistory == null
                      ? 'Belum Dikerjakan'
                      : isPassed(
                          quiz.totalQuestions!,
                          quiz.answerHistory!.correctAnswersAmt!,
                        )
                          ? 'Lulus'
                          : 'Tidak Lulus',
                  valueColor: quiz.answerHistory == null
                      ? null
                      : isPassed(
                          quiz.totalQuestions!,
                          quiz.answerHistory!.correctAnswersAmt!,
                        )
                          ? successColor
                          : errorColor,
                ),
                buildQuizInfoText(
                  title: 'Score',
                  value: quiz.answerHistory == null
                      ? '-/100'
                      : '${calculateScore(quiz.totalQuestions!, quiz.answerHistory!.correctAnswersAmt!)}/100',
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () async {
                    final value = await context.showConfirmDialog(
                      title: 'Kerjakan Quiz?',
                      message: 'Apakah kamu siap mengerjakan quiz ini?',
                      primaryButtonText: 'Kerjakan',
                      onPressedPrimaryButton: () {
                        navigatorKey.currentState!.pop(true);
                      },
                    );

                    if (value != null) {
                      final result = await navigatorKey.currentState!.pushNamed(
                        studentCourseQuizRoute,
                        arguments: quiz,
                      );

                      debugPrint(result.toString());
                    }
                  },
                  style: FilledButton.styleFrom(
                    foregroundColor: quiz.answerHistory == null ? secondaryColor : primaryColor,
                    backgroundColor: quiz.answerHistory == null ? primaryColor : secondaryColor,
                  ),
                  child: Text(
                    quiz.answerHistory == null ? 'Mulai Kerjakan!' : 'Mulai Ulang',
                  ),
                ).fullWidth(),
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
                                            materialSequenceNumber - 1,
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
                                      '${quizes[indexId - 1].title}',
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
                            if (indexId != ids.length - 1 && quiz.answerHistory != null) ...[
                              if (isPassed(
                                quiz.totalQuestions!,
                                quiz.answerHistory!.correctAnswersAmt!,
                              ))
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
                                              materialSequenceNumber + 1,
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
                                        '${quizes[indexId + 1].title}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                            ] else ...[
                              const Expanded(
                                child: SizedBox(),
                              ),
                            ],
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

  int calculateScore(int totalQuestions, int totalCorrectAnswers) {
    if (totalQuestions == 0) return 0;

    final percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;

    final score = percentageCorrect.round();

    return score;
  }

  bool isPassed(int totalQuestions, int totalCorrectAnswers) {
    final percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;

    return percentageCorrect >= 80;
  }

  void navigate(BuildContext context, int id, int materialSequenceNumber) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => StudentCourseQuizHomePage(
          id: id,
          userCourseId: userCourseId,
          curriculumSequenceNumber: curriculumSequenceNumber,
          materialSequenceNumber: materialSequenceNumber,
          totalMaterials: totalMaterials,
        ),
        transitionDuration: Duration.zero,
      ),
    );
  }
}

class StudentCourseQuizHomePageArgs {
  final int id;
  final int userCourseId;
  final int curriculumSequenceNumber;
  final int materialSequenceNumber;
  final int totalMaterials;

  const StudentCourseQuizHomePageArgs({
    required this.id,
    required this.userCourseId,
    required this.curriculumSequenceNumber,
    required this.materialSequenceNumber,
    required this.totalMaterials,
  });
}
