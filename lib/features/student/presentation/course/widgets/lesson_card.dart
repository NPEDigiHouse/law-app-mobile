// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: double.infinity,
      color: scaffoldBackgroundColor,
      radius: 8,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      onTap: () => navigatorKey.currentState!.pushNamed(
        lesson is Article
            ? studentCourseArticleRoute
            : studentCourseQuizHomeRoute,
        arguments: lesson is Article ? lesson as Article : lesson as Quiz,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        child: Row(
          children: [
            if (lesson.isComplete != null)
              const Icon(
                Icons.verified_rounded,
                color: successColor,
                size: 22,
              )
            else
              SvgAsset(
                assetPath: AssetPath.getIcon(
                  lesson is Article
                      ? 'read-outlined.svg'
                      : 'note-edit-line.svg',
                ),
                color: primaryTextColor,
                width: 20,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(lesson.title),
            ),
          ],
        ),
      ),
    );
  }
}
