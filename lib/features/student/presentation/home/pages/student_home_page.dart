// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_home_page.dart';
import 'package:law_app/features/student/presentation/home/providers/student_dashboard_provider.dart';

class StudentHomePage extends ConsumerWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(studentDashboardProvider);

    ref.listen(studentDashboardProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                ref.invalidate(studentDashboardProvider);
                navigatorKey.currentState!.pop();
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () {},
        data: (_) {},
      );
    });

    // final carouselItems = [
    //   {
    //     "img": "sample_carousel_image1.jpg",
    //     "text": "Promo Mingguan 1",
    //   },
    //   {
    //     "img": "sample_carousel_image2.jpg",
    //     "text": "Promo Mingguan 2",
    //   },
    //   {
    //     "img": "sample_carousel_image3.jpg",
    //     "text": "Promo Mingguan 3",
    //   },
    //   {
    //     "img": "sample_carousel_image4.jpg",
    //     "text": "Promo Mingguan 4",
    //   },
    // ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: dashboard.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (dashboard) {
          final discussions = dashboard.discussions;
          final books = dashboard.books;
          final dashboardData = dashboard.dashboardData;

          if (discussions == null || books == null || dashboardData == null) {
            return null;
          }

          final items = [
            {
              "icon": "chalkboard-teacher-fill.svg",
              "count": dashboardData.totalCourses,
              "text": "Course\nDiambil",
            },
            {
              "icon": "question-circle-line.svg",
              "count": dashboardData.totalDiscussions,
              "text": "Pertanyaan\nDipakai",
            },
            {
              "icon": "book-bold.svg",
              "count": dashboardData.totalBooksRead,
              "text": "Buku\nDibaca",
            },
          ];

          return SingleChildScrollView(
            child: Column(
              children: [
                HomePageHeader(
                  onPressedProfileIcon: () {
                    navigatorKey.currentState!.pushNamed(profileRoute);
                  },
                  child: Dashboard(items: items),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 86,
                //     bottom: 24,
                //   ),
                //   child: CustomCarousel(
                //     items: carouselItems,
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 86, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Diskusi Terbaru',
                              style: textTheme.titleLarge!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => navigatorKey.currentState!.pushNamed(
                              publicDiscussionRoute,
                            ),
                            child: Text(
                              'Lihat Selengkapnya >',
                              style: textTheme.bodySmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (discussions.isEmpty)
                        const EmptyContentText(
                          'Belum terdapat diskusi umum. Pertanyaan umum dari seluruh siswa akan muncul di sini.',
                        )
                      else
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return DiscussionCard(
                              discussion: discussions[index],
                              isDetail: true,
                              withProfile: true,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 8);
                          },
                          itemCount: discussions.length,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Buku Terbaru',
                              style: textTheme.titleLarge!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => navigatorKey.currentState!.pushNamed(
                              libraryBookListRoute,
                            ),
                            child: Text(
                              'Lihat Selengkapnya >',
                              style: textTheme.bodySmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (books.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Tingkatkan pengetahuanmu dengan buku-buku pilihan pakar untuk memperdalam ilmu kamu!",
                          style: textTheme.bodySmall!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 24,
                  ),
                  child: books.isEmpty
                      ? const EmptyContentText(
                          'Daftar buku belum ada. Nantikan koleksi buku-buku dari kami ya.',
                        )
                      : SizedBox(
                          height: 180,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BookItem(
                                height: 180,
                                width: 120,
                                titleMaxLines: 1,
                                book: books[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 8);
                            },
                            itemCount: books.length,
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Popular Course',
                              style: textTheme.titleLarge!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => navigatorKey.currentState!.push(
                              MaterialPageRoute(
                                builder: (_) => const StudentCourseHomePage(),
                              ),
                            ),
                            child: Text(
                              'Lihat Selengkapnya >',
                              style: textTheme.bodySmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Buruan daftar di berbagai course yang ada untuk meningkatkan pengetahuanmu tentang hukum!",
                        style: textTheme.bodySmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return CourseCard(
                            course: dummyCourses[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                      ),
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
