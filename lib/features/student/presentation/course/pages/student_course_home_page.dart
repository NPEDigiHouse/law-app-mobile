import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/animated_fab.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/student/presentation/course/widgets/course_list_bottom_sheet.dart';

class StudentCourseHomePage extends StatefulWidget {
  const StudentCourseHomePage({super.key});

  @override
  State<StudentCourseHomePage> createState() => _StudentCourseHomePageState();
}

class _StudentCourseHomePageState extends State<StudentCourseHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabAnimationController;
  late final ScrollController scrollController;

  late final List<String> categories;
  late final ValueNotifier<String> selectedCategory;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );

    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset == 0) {
          fabAnimationController.reverse();
        }
      });

    categories = ['Tersedia', 'Populer'];
    selectedCategory = ValueNotifier(categories.first);
  }

  @override
  void dispose() {
    super.dispose();

    fabAnimationController.dispose();
    scrollController.dispose();
    selectedCategory.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 116,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: HeaderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Course',
                            style: textTheme.headlineMedium!.copyWith(
                              color: accentTextColor,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconName: 'search-fill.svg',
                          color: scaffoldBackgroundColor,
                          size: 28,
                          tooltip: 'Cari',
                          onPressed: () => navigatorKey.currentState!.pushNamed(
                            studentCourseSearchRoute,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ikuti berbagai course yang ada untuk meningkatkan pengetahuanmu tentang hukum!',
                      style: textTheme.bodySmall!.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            return FunctionHelper.handleFabVisibilityOnScroll(
              notification,
              fabAnimationController,
            );
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: -1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CustomIconButton(
                                      iconName: 'book-bold.svg',
                                      color: primaryColor,
                                      size: 40,
                                      splashRadius: 8,
                                      onPressed: () {
                                        showCourseListModalBottomSheet(
                                          title: 'Course Aktif',
                                          emptyCourseTitle:
                                              'Course aktif masih kosong',
                                          emptyCourseSubtitle:
                                              'Tidak ada course yang sedang diikuti.',
                                          courses: List<Course>.generate(
                                            dummyCourses.length,
                                            (i) {
                                              return dummyCourses[i].copyWith(
                                                status: 'active',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Course Aktif',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CustomIconButton(
                                      iconName: 'history-line.svg',
                                      color: primaryColor,
                                      size: 40,
                                      splashRadius: 8,
                                      onPressed: () {
                                        showCourseListModalBottomSheet(
                                          title: 'Riwayat Course',
                                          emptyCourseTitle:
                                              'Riwayat course masih kosong',
                                          emptyCourseSubtitle:
                                              'Kamu belum pernah menyelesaikan course.',
                                          courses: [],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Riwayat Course',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Daftar Course',
                        style: textTheme.titleLarge,
                      ),
                      ValueListenableBuilder(
                        valueListenable: selectedCategory,
                        builder: (context, category, child) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List<CustomFilterChip>.generate(
                              categories.length,
                              (index) => CustomFilterChip(
                                label: categories[index],
                                selected: category == categories[index],
                                onSelected: (_) {
                                  selectedCategory.value = categories[index];
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == dummyCourses.length - 1 ? 0 : 8,
                        ),
                        child: CourseCard(
                          course: dummyCourses[index],
                        ),
                      );
                    },
                    childCount: dummyCourses.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabAnimationController: fabAnimationController,
        scrollController: scrollController,
      ),
    );
  }

  Future<void> showCourseListModalBottomSheet({
    required String title,
    required List<Course> courses,
    String? emptyCourseTitle,
    String? emptyCourseSubtitle,
  }) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CourseListBottomSheet(
          title: title,
          courses: courses,
          emptyCourseTitle: emptyCourseTitle,
          emptyCourseSubtitle: emptyCourseSubtitle,
        );
      },
    );
  }
}
