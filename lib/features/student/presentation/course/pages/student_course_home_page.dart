import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class StudentCourseHomePage extends StatefulWidget {
  const StudentCourseHomePage({super.key});

  @override
  State<StudentCourseHomePage> createState() => _StudentCourseHomePageState();
}

class _StudentCourseHomePageState extends State<StudentCourseHomePage> {
  late final List<String> courseCategories;
  late final ValueNotifier<String> selectedCategory;

  @override
  void initState() {
    super.initState();

    courseCategories = ['Tersedia', 'Populer'];
    selectedCategory = ValueNotifier(courseCategories.first);
  }

  @override
  void dispose() {
    super.dispose();

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Course',
                            style: textTheme.headlineMedium!.copyWith(
                              color: accentTextColor,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              iconName: 'search-fill.svg',
                              color: scaffoldBackgroundColor,
                              size: 28,
                              tooltip: 'Cari',
                              onPressed: () {},
                            ),
                          ],
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
        body: CustomScrollView(
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
                                    onPressed: () {},
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
                                    onPressed: () {},
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
                            courseCategories.length,
                            (index) => CustomFilterChip(
                              label: courseCategories[index],
                              selected: category == courseCategories[index],
                              onSelected: (_) {
                                selectedCategory.value =
                                    courseCategories[index];
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
            // SliverPadding(
            //   padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            //   sliver: SliverList(
            //     delegate: SliverChildBuilderDelegate(
            //       (context, index) {
            //         return Padding(
            //           padding: EdgeInsets.only(
            //             bottom: index == items.length - 1 ? 0 : 8,
            //           ),
            //           child: Container(),
            //         );
            //       },
            //       childCount: items.length,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
