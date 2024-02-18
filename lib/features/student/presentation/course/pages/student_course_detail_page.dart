import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/number_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widget/curriculum_card.dart';
import 'package:law_app/features/student/presentation/course/widget/enroll_course_dialog.dart';

class StudentCourseDetailPage extends StatelessWidget {
  final Course course;

  const StudentCourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final courseDetail = generateDummyCourseDetail(course);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Course',
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
            Hero(
              tag: course,
              transitionOnUserGestures: true,
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF4847D).withOpacity(.1),
                      const Color(0xFFE44C42).withOpacity(.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AssetPath.getImage(course.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              course.title,
              style: textTheme.headlineSmall!.copyWith(
                color: primaryColor,
              ),
            ),
            if (course.rating != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RatingBar(
                    initialRating: course.rating!,
                    onRatingUpdate: (_) {},
                    ignoreGestures: true,
                    itemSize: 18,
                    ratingWidget: RatingWidget(
                      full: SvgAsset(
                        assetPath: AssetPath.getIcon('star-solid.svg'),
                        color: primaryColor,
                      ),
                      half: SvgAsset(
                        assetPath: AssetPath.getIcon('star-solid.svg'),
                      ),
                      empty: SvgAsset(
                        assetPath: AssetPath.getIcon('star-solid.svg'),
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${course.rating}/5)',
                    style: textTheme.bodyMedium!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 4),
              Text(
                'Belum ada rating',
                style: textTheme.bodyMedium!.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgAsset(
                      assetPath: AssetPath.getIcon('clock-solid.svg'),
                      color: secondaryTextColor,
                      width: 18,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${course.completionTime} Jam',
                        style: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgAsset(
                      assetPath: AssetPath.getIcon('users-solid.svg'),
                      color: secondaryTextColor,
                      width: 18,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${course.totalStudents.toDecimalPattern()} Peserta',
                        style: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: buildActionButton(
                context: context,
                courseDetail: courseDetail,
              ),
            ),
            Text(
              'Deskripsi Kelas',
              style: textTheme.titleMedium,
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 10,
            ),
            Text(
              courseDetail.description,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Kurikulum',
              style: textTheme.titleMedium,
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 10,
            ),
            const SizedBox(height: 8),
            ...List<Padding>.generate(
              courseDetail.curriculums.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == courseDetail.curriculums.length - 1 ? 0 : 10,
                ),
                child: CurriculumCard(
                  curriculum: courseDetail.curriculums[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton({
    required BuildContext context,
    required CourseDetail courseDetail,
  }) {
    switch (course.status) {
      case null:
        return FilledButton.icon(
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => EnrollCourseDialog(courseDetail: courseDetail),
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('book-bold-plus.svg'),
            color: secondaryColor,
            width: 20,
          ),
          label: const Text('Daftar Sekarang!'),
        ).fullWidth();
      case 'active':
        return FilledButton.icon(
          onPressed: () => navigatorKey.currentState!.pushNamed(
            studentCourseProgressRoute,
            arguments: courseDetail,
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('book-bold.svg'),
            color: secondaryColor,
            width: 20,
          ),
          label: const Text('Lanjut Belajar'),
        ).fullWidth();
      case 'passed':
        return Column(
          children: [
            Text(
              'Selamat! Anda telah menyelesaikan course ini👏',
              style: textTheme.bodyMedium!.copyWith(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            FilledButton.icon(
              onPressed: () {},
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('certificate-solid.svg'),
                color: secondaryColor,
                width: 20,
              ),
              label: const Text('Lihat Sertifikat'),
            ).fullWidth(),
            FilledButton.icon(
              onPressed: () => navigatorKey.currentState!.pushNamed(
                studentCourseProgressRoute,
                arguments: courseDetail,
              ),
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('book-bold.svg'),
                color: primaryColor,
                width: 20,
              ),
              label: const Text('Belajar Lagi'),
              style: FilledButton.styleFrom(
                foregroundColor: primaryColor,
                backgroundColor: secondaryColor,
              ),
            ).fullWidth(),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
