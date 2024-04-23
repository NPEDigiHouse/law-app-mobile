// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool withLabelChip;

  const CourseCard({
    super.key,
    required this.course,
    this.withLabelChip = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      color: scaffoldBackgroundColor,
      radius: 12,
      padding: const EdgeInsets.all(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(1, 1),
          blurRadius: 4,
        ),
      ],
      onTap: () => navigatorKey.currentState!.pushNamed(
        CredentialSaver.user!.role == 'admin'
            ? adminCourseDetailRoute
            : studentCourseDetailRoute,
        arguments: course.id,
      ),
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
                    const Color(0xFFA2355A).withOpacity(.1),
                    const Color(0xFF730034).withOpacity(.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: CustomNetworkImage(
                fit: BoxFit.fitHeight,
                imageUrl: course.coverImg!,
                placeHolderSize: 24,
                aspectRatio: 1 / 1.1,
                radius: 8,
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
                  '${course.title}',
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
                        '${FunctionHelper.minutesToHours(course.courseDuration!)} jam',
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
                        '${course.enrolledMembers} peserta',
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
                    Expanded(
                      child: RatingBar(
                        initialRating: course.rating!.toDouble(),
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
                    ),
                    if (withLabelChip && course.status != null) ...[
                      const SizedBox(width: 4),
                      Builder(
                        builder: (context) {
                          Color getColor() {
                            switch (course.status) {
                              case 'ACTIVE':
                                return infoColor;
                              case 'COMPLETE':
                                return successColor;
                              default:
                                return secondaryTextColor;
                            }
                          }

                          return LabelChip(
                            text: course.status!.toLowerCase().toCapitalize(),
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
