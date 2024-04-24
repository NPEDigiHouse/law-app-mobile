// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/enums/course_material_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/curriculum_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_detail_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/material_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widgets/material_card.dart';

class StudentCourseMaterialPage extends ConsumerWidget {
  final int curriculumId;
  final int userCourseId;

  const StudentCourseMaterialPage({
    super.key,
    required this.curriculumId,
    required this.userCourseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(CurriculumDetailProvider(id: curriculumId));
    final userCourse = ref
        .watch(UserCourseDetailProvider(id: userCourseId))
        .unwrapPrevious()
        .valueOrNull;

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

    return Scaffold(
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

          var materialSequenceNumber = 0;

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
                ...List<Padding>.generate(
                  curriculum.articles!.length,
                  (index) {
                    materialSequenceNumber = index;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            index == curriculum.articles!.length - 1 ? 0 : 8,
                      ),
                      child: MaterialCard(
                        userCourseId: userCourse?.id ?? 0,
                        curriculumSequenceNumber: curriculum.sequenceNumber!,
                        materialSequenceNumber: materialSequenceNumber,
                        material: curriculum.articles![index],
                        type: CourseMaterialType.article,
                        isCompleted: isMaterialCompleted(
                          userCourse,
                          curriculum.sequenceNumber!,
                          materialSequenceNumber,
                        ),
                        isLocked: isMaterialLocked(
                          userCourse,
                          curriculum.sequenceNumber!,
                          materialSequenceNumber,
                        ),
                        totalMaterials: curriculum.articles!.length +
                            curriculum.quizzes!.length,
                      ),
                    );
                  },
                ),
                if (curriculum.articles!.isNotEmpty) const SizedBox(height: 8),
                ...List<Padding>.generate(
                  curriculum.quizzes!.length,
                  (index) {
                    materialSequenceNumber++;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == curriculum.quizzes!.length - 1 ? 0 : 8,
                      ),
                      child: MaterialCard(
                        userCourseId: userCourse?.id ?? 0,
                        curriculumSequenceNumber: curriculum.sequenceNumber!,
                        materialSequenceNumber: materialSequenceNumber,
                        material: curriculum.quizzes![index],
                        type: CourseMaterialType.quiz,
                        isCompleted: isMaterialCompleted(
                          userCourse,
                          curriculum.sequenceNumber!,
                          materialSequenceNumber,
                        ),
                        isLocked: isMaterialLocked(
                          userCourse,
                          curriculum.sequenceNumber!,
                          materialSequenceNumber,
                        ),
                        totalMaterials: curriculum.articles!.length +
                            curriculum.quizzes!.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool isMaterialCompleted(
    UserCourseModel? userCourse,
    int curriculumSequenceNumber,
    int materialSequenceNumber,
  ) {
    if (userCourse == null) {
      return false;
    }

    if (userCourse.currentCurriculumSequence! > curriculumSequenceNumber) {
      return true;
    }

    return userCourse.currentMaterialSequence! > materialSequenceNumber;
  }

  bool isMaterialLocked(
    UserCourseModel? userCourse,
    int curriculumSequenceNumber,
    int materialSequenceNumber,
  ) {
    if (userCourse == null) {
      return false;
    }

    if (userCourse.currentCurriculumSequence! < curriculumSequenceNumber) {
      return true;
    }

    return userCourse.currentMaterialSequence! < materialSequenceNumber;
  }
}

class StudentCourseMaterialPageArgs {
  final int curriculumId;
  final int userCourseId;

  const StudentCourseMaterialPageArgs({
    required this.curriculumId,
    required this.userCourseId,
  });
}
