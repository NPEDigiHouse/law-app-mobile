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
import 'package:law_app/features/admin/presentation/course/pages/admin_course_quiz_form_page.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuizPage extends ConsumerWidget {
  final int id;

  const AdminCourseQuizPage({super.key, required this.id});

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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Detail Quiz',
              withBackButton: true,
              withTrailingButton: true,
              trailingButtonIconName: 'pencil-solid.svg',
              trailingButtonTooltip: 'Edit',
              onPressedTrailingButton: () {
                navigatorKey.currentState!.pushNamed(
                  adminCourseQuizFormRoute,
                  arguments: AdminCourseQuizFormPageArgs(
                    title: 'Edit Quiz',
                    quiz: quiz,
                  ),
                );
              },
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
                  value: '0 soal',
                ),
                buildQuizInfoText(
                  title: 'Waktu Pengerjaan',
                  value: '${quiz.duration} menit',
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => navigatorKey.currentState!.pushNamed(
                    adminCourseQuestionListRoute,
                    arguments: quiz.id,
                  ),
                  child: const Text('Lihat Daftar Soal'),
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
                                          navigate(context, ids[indexId - 1]);
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
                                          navigate(context, ids[indexId + 1]);
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

  void navigate(BuildContext context, int id) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AdminCourseQuizPage(id: id),
        transitionDuration: Duration.zero,
      ),
    );
  }
}
