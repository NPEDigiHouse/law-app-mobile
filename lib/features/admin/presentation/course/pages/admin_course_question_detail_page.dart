// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_question_form_page.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_option_card.dart';
import 'package:law_app/features/shared/providers/course_providers/question_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuestionDetailPage extends ConsumerWidget {
  final int id;
  final int number;

  const AdminCourseQuestionDetailPage({
    super.key,
    required this.id,
    required this.number,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionIds = ref.watch(questionIdsProvider);
    final indexId = questionIds.indexOf(id);

    final data = ref.watch(QuestionDetailProvider(id: id));

    ref.listen(QuestionDetailProvider(id: id), (_, state) {
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Pertanyaan',
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: 'pencil-solid.svg',
          trailingButtonTooltip: 'Edit',
          onPressedTrailingButton: () => navigatorKey.currentState!.pushNamed(
            adminCourseQuestionFormRoute,
            arguments: AdminCourseQuestionFormPageArgs(
              id: id,
              number: number,
            ),
          ),
        ),
      ),
      body: data.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final question = data.question;
          final options = data.options;

          if (question == null || options == null) return null;

          final optionKeys = ['A', 'B', 'C', 'D'];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan #$number',
                  style: textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text('${question.title}'),
                const SizedBox(height: 20),
                if (options.isNotEmpty) ...[
                  ...List<Padding>.generate(
                    options.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == options.length - 1 ? 0 : 8,
                      ),
                      child: AdminOptionCard(
                        optionKey: optionKeys[index],
                        option: options[index],
                        isCorrectOption:
                            question.correctOptionId == options[index].id,
                        preventAction: true,
                      ),
                    ),
                  ),
                ] else ...[
                  const EmptyContentText(
                    'Pertanyaan ini belum memiliki pilihan jawaban. Tekan tombol "Edit" untuk menambahkan beberapa opsi jawaban.',
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: questionIds.length > 1
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
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: secondaryColor,
                              ),
                              child: IconButton(
                                onPressed: () => navigate(
                                  context,
                                  questionIds[indexId - 1],
                                  number - 1,
                                ),
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
                          )
                        else
                          const Expanded(
                            child: SizedBox(),
                          ),
                        const SizedBox(width: 10),
                        if (indexId != questionIds.length - 1)
                          Expanded(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: secondaryColor,
                              ),
                              child: IconButton(
                                onPressed: () => navigate(
                                  context,
                                  questionIds[indexId + 1],
                                  number + 1,
                                ),
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
  }

  void navigate(BuildContext context, int id, int number) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AdminCourseQuestionDetailPage(
          id: id,
          number: number,
        ),
        transitionDuration: Duration.zero,
      ),
    );
  }
}

class AdminCourseQuestionDetailPageArgs {
  final int id;
  final int number;

  const AdminCourseQuestionDetailPageArgs({
    required this.id,
    required this.number,
  });
}
