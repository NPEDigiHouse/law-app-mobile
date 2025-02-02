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
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_post_model.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_curriculum_card.dart';
import 'package:law_app/features/shared/providers/course_providers/course_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/curriculum_actions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseCurriculumPage extends ConsumerWidget {
  final int id;

  const AdminCourseCurriculumPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(CourseDetailProvider(id: id));

    ref.listen(curriculumActionsProvider, (_, state) {
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

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: course.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final course = data.course;

          if (course == null) return null;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
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
                        placeHolderSize: 64,
                        aspectRatio: 3 / 2,
                      ),
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      foregroundColor: scaffoldBackgroundColor,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: true,
                      title: Text(
                        'Kurikulum',
                        style: textTheme.titleLarge!.copyWith(
                          color: scaffoldBackgroundColor,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () => navigatorKey.currentState!.pop(),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('caret-line-left.svg'),
                          color: scaffoldBackgroundColor,
                          width: 24,
                        ),
                        tooltip: 'Kembali',
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgAsset(
                                assetPath: AssetPath.getIcon('clock-solid.svg'),
                                color: accentTextColor,
                                width: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Durasi belajar sekitar ${FunctionHelper.minutesToHours(course.courseDuration!)} jam',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: accentTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${course.title}',
                            style: textTheme.titleLarge!.copyWith(
                              color: scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kurikulum',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      if (course.curriculums!.isEmpty)
                        const EmptyContentText(
                          'Kurikulum pada course ini masih kosong!',
                        )
                      else
                        ...List<Padding>.generate(
                          course.curriculums!.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == course.curriculums!.length - 1 ? 0 : 8,
                            ),
                            child: AdminCurriculumCard(
                              curriculum: course.curriculums![index],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () => context.showSingleFormDialog(
                          title: 'Tambah Kurikulum',
                          name: 'title',
                          label: 'Nama Kurikulum',
                          hintText: 'Masukkan nama kurikulum',
                          primaryButtonText: 'Tambah',
                          onSubmitted: (value) {
                            navigatorKey.currentState!.pop();

                            ref.read(curriculumActionsProvider.notifier).createCurriculum(
                                  curriculum: CurriculumPostModel(
                                    title: value['title'],
                                    courseId: course.id!,
                                  ),
                                );
                          },
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Tambah Kurikulum'),
                      ).fullWidth(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
