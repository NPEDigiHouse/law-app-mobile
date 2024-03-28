// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_form_page.dart';
import 'package:law_app/features/shared/providers/course_providers/course_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/course_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseHomePage extends ConsumerWidget {
  const AdminCourseHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final courses = ref.watch(CourseProvider(query: query));

    ref.listen(CourseProvider(query: query), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(courseProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(courseActionsProvider, (_, state) {
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
            ref.invalidate(courseProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
          color: scaffoldBackgroundColor,
          child: HeaderContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: secondaryColor,
                      ),
                      child: IconButton(
                        onPressed: () => context.back(),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('caret-line-left.svg'),
                          color: primaryColor,
                          width: 24,
                        ),
                        tooltip: 'Kembali',
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Kelola Course',
                          style: textTheme.titleLarge!.copyWith(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchField(
                  text: query,
                  hintText: 'Cari course',
                  onChanged: (query) => searchCourse(ref, query),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      body: courses.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final courses = data.courses;
          final hasMore = data.hasMore;

          if (courses == null || hasMore == null) return null;

          if (query.isNotEmpty && courses.isEmpty) {
            return const CustomInformation(
              illustrationName: 'lawyer-cuate.svg',
              title: 'Course Tidak Ditemukan',
              subtitle: 'Nama course tersebut tidak tersedia.',
              size: 225,
            );
          }

          if (courses.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Daftar course masih kosong',
              subtitle: 'Tambahkan course dengan menekan tombol di bawah.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              if (index >= courses.length) {
                return buildFetchMoreButton(ref, query, courses.length);
              }

              return CourseCard(course: courses[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: hasMore ? courses.length + 1 : courses.length,
          );
        },
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
          onPressed: () => navigatorKey.currentState!.pushNamed(
            adminCourseFormRoute,
            arguments: const AdminCourseFormPageArgs(title: 'Tambah Course'),
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: scaffoldBackgroundColor,
            width: 24,
          ),
          tooltip: 'Tambah',
        ),
      ),
    );
  }

  TextButton buildFetchMoreButton(
    WidgetRef ref,
    String query,
    int currentLength,
  ) {
    return TextButton(
      onPressed: () {
        ref
            .read(CourseProvider(
              query: query,
            ).notifier)
            .fetchMoreCourses(
              query: query,
              offset: currentLength,
            );
      },
      child: const Text('Lihat lebih banyak'),
    );
  }

  void searchCourse(WidgetRef ref, String query) {
    if (query.isNotEmpty) {
      ref.read(CourseProvider(query: query));
    }

    ref.read(queryProvider.notifier).state = query;
  }
}
