// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/number_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseDetailPage extends StatelessWidget {
  final Course course;
  const AdminCourseDetailPage({super.key, required this.course});
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
                      const Color(0xFFA2355A).withOpacity(.1),
                      const Color(0xFF730034).withOpacity(.5),
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
              child: FilledButton.icon(
                onPressed: () => navigatorKey.currentState!.pushNamed(
                  adminCourseCurriculumRoute,
                  arguments: courseDetail,
                ),
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon('book-bold.svg'),
                  color: secondaryColor,
                  width: 20,
                ),
                label: const Text('Lihat Kurikulum'),
              ).fullWidth(),
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
          ],
        ),
      ),
    );
  }
}
