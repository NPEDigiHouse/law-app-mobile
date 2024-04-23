// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/course_providers/course_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class StudentCourseSearchPage extends ConsumerWidget {
  const StudentCourseSearchPage({super.key});

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(124),
        child: HeaderContainer(
          child: Column(
            children: [
              Text(
                'Cari Course',
                style: textTheme.titleMedium!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 10),
              SearchField(
                text: query,
                hintText: 'Cari nama course',
                autoFocus: true,
                onChanged: (query) => searchCourse(ref, query),
              ),
            ],
          ),
        ),
      ),
      body: courses.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final courses = data.courses;
          final hasMore = data.hasMore;

          if (courses == null || hasMore == null) return null;

          if (courses.isEmpty && query.trim().isNotEmpty) {
            return const CustomInformation(
              illustrationName: 'lawyer-cuate.svg',
              title: 'Course tidak ditemukan',
              subtitle: 'Nama course tersebut tidak tersedia.',
              size: 225,
            );
          }

          if (courses.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Daftar course masih kosong',
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
    if (query.trim().isNotEmpty) {
      ref.read(CourseProvider(query: query));
    }

    ref.read(queryProvider.notifier).state = query;
  }
}
