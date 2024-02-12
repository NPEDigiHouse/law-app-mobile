import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: scaffoldBackgroundColor,
      padding: const EdgeInsets.all(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(2, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
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
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1 / 1.1,
                  child: Image.asset(
                    AssetPath.getImage(course.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgAsset(
                      assetPath: AssetPath.getIcon('clock-solid.svg'),
                      color: secondaryTextColor,
                      width: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${course.completionTime} jam',
                        style: textTheme.bodySmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgAsset(
                      assetPath: AssetPath.getIcon('users-solid.svg'),
                      color: secondaryTextColor,
                      width: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${course.totalStudents} peserta',
                        style: textTheme.bodySmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (course.rating != null)
                      Expanded(
                        child: RatingBar(
                          initialRating: course.rating!,
                          onRatingUpdate: (_) {},
                          ignoreGestures: true,
                          itemSize: 15,
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
                      )
                    else
                      Expanded(
                        child: Text(
                          'Belum ada rating',
                          style: textTheme.bodySmall!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    if (course.status != null) ...[
                      const SizedBox(width: 4),
                      Builder(
                        builder: (context) {
                          Color getColor() {
                            switch (course.status!) {
                              case 'active':
                                return infoColor;
                              case 'passed':
                                return successColor;
                              default:
                                return secondaryTextColor;
                            }
                          }

                          return LabelChip(
                            text: course.status!.toCapitalize(),
                            color: getColor(),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
