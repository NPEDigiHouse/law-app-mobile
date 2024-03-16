// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AdminCourseSearchPage extends StatefulWidget {
  const AdminCourseSearchPage({super.key});

  @override
  State<AdminCourseSearchPage> createState() => _AdminCourseSearchPageState();
}

class _AdminCourseSearchPageState extends State<AdminCourseSearchPage> {
  late final ValueNotifier<String> query;
  late List<Course> courses;
  late List<Course> courseHistoryList;

  @override
  void initState() {
    super.initState();

    query = ValueNotifier('');
    courses = dummyCourses;
    courseHistoryList = dummyCourses.sublist(0, 3);
  }

  @override
  void dispose() {
    super.dispose();

    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              ValueListenableBuilder(
                valueListenable: query,
                builder: (context, query, child) {
                  return SearchField(
                    text: query,
                    hintText: 'Cari nama course',
                    autoFocus: true,
                    onChanged: searchCourse,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (query.value.isEmpty) {
            if (courseHistoryList.isEmpty) {
              return const CustomInformation(
                illustrationName: 'house-searching-cuate.svg',
                title: 'Riwayat pencarian',
                subtitle: 'Riwayat pencarian course masih kosong.',
              );
            }

            return buildCourseHistoryList();
          }

          if (courses.isEmpty) {
            return const CustomInformation(
              illustrationName: 'lawyer-cuate.svg',
              title: 'Course Tidak Ditemukan',
              subtitle: 'Nama course tersebut tidak tersedia.',
              size: 230,
            );
          }

          return buildCourseResultList();
        },
      ),
    );
  }

  CustomScrollView buildCourseHistoryList() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '*Swipe ke samping untuk menghapus history buku',
                  style: textTheme.labelSmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Riwayat Pencarian',
                        style: textTheme.titleLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.showConfirmDialog(
                        title: 'Konfirmasi',
                        message:
                            'Anda yakin ingin menghapus seluruh riwayat pencarian?',
                        onPressedPrimaryButton: () {},
                      ),
                      child: Text(
                        'Hapus Semua',
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Dismissible(
                  key: ValueKey<String>(courseHistoryList[index].title),
                  onDismissed: (_) {
                    setState(() {
                      courseHistoryList.removeWhere((course) {
                        return course.title == courseHistoryList[index].title;
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CourseCard(
                      course: courseHistoryList[index],
                    ),
                  ),
                );
              },
              childCount: courseHistoryList.length,
            ),
          ),
        ),
      ],
    );
  }

  ListView buildCourseResultList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        return CourseCard(
          course: courses[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: courses.length,
    );
  }

  void searchCourse(String query) {
    this.query.value = query;

    final result = dummyCourses.where((course) {
      final queryLower = query.toLowerCase();
      final titleLower = course.title.toLowerCase();

      return titleLower.contains(queryLower);
    }).toList();

    setState(() => courses = result);
  }
}
