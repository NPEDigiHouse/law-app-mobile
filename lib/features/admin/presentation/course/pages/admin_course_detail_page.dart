// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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
import 'package:law_app/features/shared/providers/course_providers/course_detail_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseDetailPage extends ConsumerWidget {
  final int id;

  const AdminCourseDetailPage({super.key, required this.id});
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

    return course.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (course) {
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
                // if (course.rating != null) ...[
                //   const SizedBox(height: 8),
                //   Row(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       RatingBar(
                //         initialRating: course.rating!,
                //         onRatingUpdate: (_) {},
                //         ignoreGestures: true,
                //         itemSize: 18,
                //         ratingWidget: RatingWidget(
                //           full: SvgAsset(
                //             assetPath: AssetPath.getIcon('star-solid.svg'),
                //             color: primaryColor,
                //           ),
                //           half: SvgAsset(
                //             assetPath: AssetPath.getIcon('star-solid.svg'),
                //           ),
                //           empty: SvgAsset(
                //             assetPath: AssetPath.getIcon('star-solid.svg'),
                //             color: secondaryColor,
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       Text(
                //         '(${course.rating}/5)',
                //         style: textTheme.bodyMedium!.copyWith(
                //           color: primaryColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ] else ...[
                //   const SizedBox(height: 4),
                //   Text(
                //     'Belum ada rating',
                //     style: textTheme.bodyMedium!.copyWith(
                //       color: secondaryTextColor,
                //     ),
                //   ),
                // ],
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
                            'Belum ada peserta',
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
                      arguments: course,
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
                  '${course.description}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: GradientColors.redPastel,
              ),
            ),
            child: IconButton(
              onPressed: () {},
              // onPressed: () => navigatorKey.currentState!.pushNamed(
              //   bookManagementFormRoute,
              //   arguments: BookManagementFormPageArgs(
              //     title: 'Edit Buku',
              //     book: book,
              //   ),
              // ),
              icon: SvgAsset(
                assetPath: AssetPath.getIcon('pencil-solid.svg'),
                color: scaffoldBackgroundColor,
                width: 24,
              ),
              tooltip: 'Edit',
            ),
          ),
        );
      },
    );
  }
}
