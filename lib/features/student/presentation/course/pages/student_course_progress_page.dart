// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_detail_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_material_page.dart';
import 'package:law_app/features/student/presentation/course/widgets/curriculum_card.dart';

class StudentCourseProgressPage extends ConsumerWidget {
  final int id;

  const StudentCourseProgressPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCourse = ref.watch(UserCourseDetailProvider(id: id));

    ref.listen(UserCourseDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(userCourseDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: userCourse.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (userCourse) {
          if (userCourse == null) return null;

          final course = userCourse.course!;
          final progressPercentage = getProgressPercentage(
            userCourse.currentCurriculumSequence!,
            course.curriculums!.length,
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFA2355A).withOpacity(.1),
                            const Color(0xFF730034).withOpacity(.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: CustomNetworkImage(
                        imageUrl: course.coverImg!,
                        placeHolderSize: 64,
                        aspectRatio: 3 / 2,
                      ),
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      foregroundColor: scaffoldBackgroundColor,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: true,
                      title: Text(
                        'Progress Course',
                        style: textTheme.titleLarge!.copyWith(
                          color: scaffoldBackgroundColor,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () => navigatorKey.currentState!.pop(),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('caret-line-left.svg'),
                          color: scaffoldBackgroundColor,
                          width: 24,
                        ),
                        tooltip: 'Kembali',
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgAsset(
                                assetPath: AssetPath.getIcon('clock-solid.svg'),
                                color: accentTextColor,
                                width: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Durasi belajar sekitar ${FunctionHelper.minutesToHours(course.courseDuration!)} jam',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: accentTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${course.title}',
                            style: textTheme.titleLarge!.copyWith(
                              color: scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progres Belajar',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearPercentIndicator(
                        lineHeight: 10,
                        barRadius: const Radius.circular(10),
                        padding: const EdgeInsets.only(right: 8),
                        animation: true,
                        animationDuration: 1000,
                        curve: Curves.easeIn,
                        percent: progressPercentage,
                        progressColor: successColor,
                        backgroundColor: secondaryTextColor,
                        trailing: Text(
                          '${(progressPercentage * 100).toInt()}%',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 8,
                        ),
                        child: Text(
                          'Kurikulum',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      ...List<Padding>.generate(
                        course.curriculums!.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == course.curriculums!.length - 1 ? 0 : 8,
                          ),
                          child: CurriculumCard(
                            showDetail: true,
                            curriculum: course.curriculums![index],
                            isCompleted: course.curriculums![index].sequenceNumber! <
                                userCourse.currentCurriculumSequence!,
                            isLocked: course.curriculums![index].sequenceNumber! >
                                userCourse.currentCurriculumSequence!,
                            onTap: () => navigatorKey.currentState!.pushNamed(
                              studentCourseMaterialRoute,
                              arguments: StudentCourseMaterialPageArgs(
                                curriculumId: course.curriculums![index].id!,
                                userCourseId: userCourse.id!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double getProgressPercentage(int currentCurriculum, int totalCurriculum) {
    return totalCurriculum == 0 ? 1 : (currentCurriculum / totalCurriculum);
  }
}
