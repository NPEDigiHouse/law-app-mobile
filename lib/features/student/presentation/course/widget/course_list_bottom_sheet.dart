import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';

class CourseListBottomSheet extends StatelessWidget {
  final String title;
  final List<Course> courses;
  final String? emptyCourseTitle;
  final String? emptyCourseSubtitle;

  const CourseListBottomSheet({
    super.key,
    required this.title,
    required this.courses,
    this.emptyCourseTitle,
    this.emptyCourseSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      snap: true,
      shouldCloseOnMinExtent: false,
      initialChildSize: courses.isEmpty ? .6 : .5,
      minChildSize: courses.isEmpty ? .6 : .5,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: Container(
            color: scaffoldBackgroundColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: textTheme.titleLarge,
                              ),
                            ),
                            CustomIconButton(
                              iconName: 'close-line.svg',
                              color: primaryTextColor,
                              size: 24,
                              tooltip: 'Tutup',
                              onPressed: () => navigatorKey.currentState!.pop(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                courses.isEmpty ? buildEmptyCourse() : buildCourseList(),
              ],
            ),
          ),
        );
      },
    );
  }

  SliverFillRemaining buildEmptyCourse() {
    return SliverFillRemaining(
      child: CustomInformation(
        illustrationName: 'lawyer-cuate.svg',
        title: '$emptyCourseTitle',
        subtitle: '$emptyCourseSubtitle',
        size: 210,
      ),
    );
  }

  SliverPadding buildCourseList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == courses.length - 1 ? 0 : 12,
              ),
              child: CourseCard(
                course: courses[index],
              ),
            );
          },
          childCount: courses.length,
        ),
      ),
    );
  }
}
