import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widget/lesson_card.dart';

class StudentCourseLessonPage extends StatelessWidget {
  final Curriculum curriculum;

  const StudentCourseLessonPage({super.key, required this.curriculum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Materi Kurikulum',
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
            Text(
              curriculum.title,
              style: textTheme.headlineSmall!.copyWith(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
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
                    'Total durasi materi sekitar ${curriculum.completionTime} menit',
                    style: textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List<Padding>.generate(
              curriculum.lessons.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == curriculum.lessons.length - 1 ? 0 : 10,
                ),
                child: LessonCard(
                  lesson: curriculum.lessons[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
