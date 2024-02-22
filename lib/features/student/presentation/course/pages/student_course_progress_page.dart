// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widgets/curriculum_card.dart';

class StudentCourseProgressPage extends StatelessWidget {
  final CourseDetail courseDetail;

  const StudentCourseProgressPage({super.key, required this.courseDetail});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.back();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
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
                          const Color(0xFFF4847D).withOpacity(.4),
                          const Color(0xFFE44C42).withOpacity(.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Image.asset(
                      AssetPath.getImage(courseDetail.image),
                      fit: BoxFit.fill,
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
                      onPressed: () => context.back(),
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
                      children: [
                        Row(
                          children: [
                            SvgAsset(
                              assetPath: AssetPath.getIcon('clock-solid.svg'),
                              color: accentTextColor,
                              width: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Total jam belajar sekitar ${courseDetail.completionTime} jam',
                                style: textTheme.bodyMedium!.copyWith(
                                  color: accentTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          courseDetail.title,
                          style: textTheme.headlineSmall!.copyWith(
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
                      percent: courseDetail.completePercentage! / 100,
                      progressColor: successColor,
                      backgroundColor: secondaryTextColor,
                      trailing: Text(
                        '${courseDetail.completePercentage!.toInt()}%',
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
                      courseDetail.curriculums.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == courseDetail.curriculums.length - 1
                              ? 0
                              : 10,
                        ),
                        child: CurriculumCard(
                          curriculum: courseDetail.curriculums[index],
                          showDetail: true,
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            studentCourseLessonRoute,
                            arguments: courseDetail.curriculums[index],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => navigatorKey.currentState!.pushNamed(
                        studentCourseRateRoute,
                        arguments: courseDetail,
                      ),
                      child: const Text('Dapatkan Sertifikat'),
                    ).fullWidth(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
