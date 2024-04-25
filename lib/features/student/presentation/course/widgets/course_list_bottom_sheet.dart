// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class CourseListBottomSheet extends ConsumerWidget {
  final String title;
  final String status;
  final String emptyTitle;
  final String emptySubtitle;

  const CourseListBottomSheet({
    super.key,
    required this.title,
    required this.status,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCourses = ref.watch(
      UserCourseProvider(
        userId: CredentialSaver.user!.id!,
        status: status.toUpperCase(),
      ),
    );

    ref.listen(
      UserCourseProvider(
        userId: CredentialSaver.user!.id!,
        status: status.toUpperCase(),
      ),
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            context.showBanner(message: '$error', type: BannerType.error);
          },
        );
      },
    );

    return userCourses.when(
      loading: () => buildDraggableScrollableSheet(),
      error: (_, __) => buildDraggableScrollableSheet(),
      data: (userCourses) => buildDraggableScrollableSheet(
        userCourses: userCourses,
      ),
    );
  }

  DraggableScrollableSheet buildDraggableScrollableSheet({
    List<UserCourseModel>? userCourses,
  }) {
    return DraggableScrollableSheet(
      snap: true,
      shouldCloseOnMinExtent: false,
      initialChildSize: .6,
      minChildSize: .6,
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
                if (userCourses != null)
                  userCourses.isEmpty ? buildEmptyUserCourse() : buildUserCourseList(userCourses)
                else
                  const SliverFillRemaining(
                    child: LoadingIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  SliverFillRemaining buildEmptyUserCourse() {
    return SliverFillRemaining(
      child: CustomInformation(
        illustrationName: 'lawyer-cuate.svg',
        title: emptyTitle,
        subtitle: emptySubtitle,
        size: 210,
      ),
    );
  }

  SliverPadding buildUserCourseList(List<UserCourseModel> userCourses) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == userCourses.length - 1 ? 0 : 12,
              ),
              child: CourseCard(
                course: userCourses[index].course!,
                withLabelChip: true,
              ),
            );
          },
          childCount: userCourses.length,
        ),
      ),
    );
  }
}
