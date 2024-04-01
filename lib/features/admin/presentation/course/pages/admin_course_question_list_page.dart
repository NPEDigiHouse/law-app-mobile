// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/question_post_model.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_question_card.dart';
import 'package:law_app/features/shared/providers/course_providers/question_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/question_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuestionListPage extends ConsumerWidget {
  final int quizId;

  const AdminCourseQuestionListPage({super.key, required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(QuestionProvider(quizId: quizId));

    ref.watch(questionIdsProvider);

    ref.listen(QuestionProvider(quizId: quizId), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(questionProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (questions) {
          if (questions != null) {
            ref.read(questionIdsProvider.notifier).update((_) {
              return questions.map((e) => e.id!).toList();
            });
          }
        },
      );
    });

    ref.listen(questionActionsProvider, (_, state) {
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

            ref.invalidate(questionProvider);
            ref.invalidate(QuizDetailProvider(id: quizId));
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Daftar Soal',
          withBackButton: true,
        ),
      ),
      body: questions.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (questions) {
          if (questions == null) return null;

          if (questions.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Belum ada pertanyaan',
              subtitle: 'Pertanyaan pada quiz ini masih kosong.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              return AdminQuestionCard(
                number: index + 1,
                question: questions[index],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: questions.length,
          );
        },
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
          onPressed: () => context.showSingleFormDialog(
            title: 'Tambah Pertanyaan',
            name: 'title',
            label: 'Pertanyaan',
            hintText: 'Masukkan pertanyaan',
            maxLines: 5,
            primaryButtonText: 'Tambah',
            onSubmitted: (value) {
              navigatorKey.currentState!.pop();

              ref.read(questionActionsProvider.notifier).createQuestion(
                    question: QuestionPostModel(
                      title: value['title'],
                      quizId: quizId,
                    ),
                  );
            },
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: scaffoldBackgroundColor,
            width: 24,
          ),
          tooltip: 'Tambah',
        ),
      ),
    );
  }
}
