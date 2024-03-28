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
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_question_form_page.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_question_card.dart';
import 'package:law_app/features/shared/providers/course_providers/question_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/question_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuestionListPage extends ConsumerWidget {
  final int quizId;

  const AdminCourseQuestionListPage({super.key, required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final questions = ref.watch(QuestionProvider(quizId: quizId));

    // ref.listen(QuestionProvider(quizId: quizId), (_, state) {
    //   state.whenOrNull(
    //     error: (error, _) {
    //       if ('$error' == kNoInternetConnection) {
    //         context.showNetworkErrorModalBottomSheet(
    //           onPressedPrimaryButton: () {
    //             navigatorKey.currentState!.pop();
    //             ref.invalidate(questionProvider);
    //           },
    //         );
    //       } else {
    //         context.showBanner(message: '$error', type: BannerType.error);
    //       }
    //     },
    //   );
    // });

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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        itemBuilder: (context, index) {
          return AdminQuestionCard(
            question: QuestionModel(
              id: 1,
              title: 'Pertanyaan #${index + 1}',
              correctOptionId: 1,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemCount: 5,
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
          onPressed: () => navigatorKey.currentState!.pushNamed(
            adminCourseQuestionFormRoute,
            arguments: const AdminCourseQuestionFormPageArgs(
              title: 'Tambah Pertanyaan',
            ),
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
