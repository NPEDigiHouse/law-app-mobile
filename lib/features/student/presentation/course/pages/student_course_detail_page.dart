// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/course_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_actions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/widgets/curriculum_card.dart';
import 'package:law_app/features/student/presentation/course/widgets/enroll_course_dialog.dart';

class StudentCourseDetailPage extends ConsumerWidget {
  final int id;

  const StudentCourseDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(CourseDetailProvider(id: id));

    ref.listen(CourseDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(courseDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(userCourseActionsProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();
            ref.invalidate(courseDetailProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    return course.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (data) {
        final course = data.course;
        final userCourse = data.userCourse;

        if (course == null) return const Scaffold();

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
                DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                    placeHolderSize: 48,
                    aspectRatio: 3 / 2,
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${course.title}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingBar(
                      initialRating: course.rating!.toDouble(),
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
                      '(${course.rating?.toDouble()}/5)',
                      style: textTheme.bodyMedium!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
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
                            '${FunctionHelper.minutesToHours(course.courseDuration!)} jam',
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
                            '${course.enrolledMembers} peserta',
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
                    course: course,
                    userCourse: userCourse,
                  ),
                ),
                Text(
                  'Deskripsi Kelas',
                  style: textTheme.titleMedium,
                ),
                Divider(
                  color: Theme.of(context).dividerColor,
                  height: 16,
                ),
                Text(
                  '${course.description}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Kurikulum',
                  style: textTheme.titleMedium,
                ),
                Divider(
                  color: Theme.of(context).dividerColor,
                  height: 16,
                ),
                const SizedBox(height: 8),
                ...List<Padding>.generate(
                  course.curriculums!.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == course.curriculums!.length - 1 ? 0 : 10,
                    ),
                    child: CurriculumCard(
                      curriculum: course.curriculums![index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildActionButton({
    required BuildContext context,
    required CourseModel course,
    UserCourseModel? userCourse,
  }) {
    if (userCourse == null) {
      return FilledButton.icon(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => EnrollCourseDialog(course: course),
        ),
        icon: SvgAsset(
          assetPath: AssetPath.getIcon('book-bold-plus.svg'),
          color: secondaryColor,
          width: 20,
        ),
        label: const Text('Daftar Sekarang!'),
      ).fullWidth();
    }

    if (userCourse.status == 'ACTIVE') {
      return FilledButton.icon(
        onPressed: () => navigatorKey.currentState!.pushNamed(
          studentCourseProgressRoute,
          arguments: userCourse.id,
        ),
        icon: SvgAsset(
          assetPath: AssetPath.getIcon('book-bold.svg'),
          color: secondaryColor,
          width: 20,
        ),
        label: const Text('Lanjut Belajar'),
      ).fullWidth();
    }

    if (userCourse.status == 'COMPLETE') {
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
              // arguments: courseDetail,
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
    }

    return const SizedBox();
  }
}
