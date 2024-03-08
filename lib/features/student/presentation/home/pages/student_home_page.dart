// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_home_page.dart';
import 'package:law_app/features/student/presentation/home/widgets/custom_carousel.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      {
        "icon": "chalkboard-teacher-fill.svg",
        "count": 2,
        "text": "Course\nDiambil",
      },
      {
        "icon": "question-circle-line.svg",
        "count": 20,
        "text": "Pertanyaan\nDipakai",
      },
      {
        "icon": "book-bold.svg",
        "count": 9,
        "text": "Buku\nDibaca",
      },
    ];

    final carouselItems = [
      {
        "img": "sample_carousel_image1.jpg",
        "text": "Promo Mingguan 1",
      },
      {
        "img": "sample_carousel_image2.jpg",
        "text": "Promo Mingguan 2",
      },
      {
        "img": "sample_carousel_image3.jpg",
        "text": "Promo Mingguan 3",
      },
      {
        "img": "sample_carousel_image4.jpg",
        "text": "Promo Mingguan 4",
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(
              onPressedProfileIcon: () => navigatorKey.currentState!.pushNamed(
                profileRoute,
              ),
              child: Dashboard(
                items: dashboardItems,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 86,
                bottom: 24,
              ),
              child: CustomCarousel(
                items: carouselItems,
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
                          'Sedang Hangat',
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
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const SizedBox();
                      // return DiscussionCard(
                      //   question: dummyQuestions[index],
                      //   role: 'student',
                      // );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
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
                  const SizedBox(height: 4),
                  Text(
                    "Tingkatkan pengetahuanmu dengan buku-buku pilihan pakar untuk memperdalam ilmu kamu!",
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 24,
              ),
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const SizedBox();
                    // return BookItem(
                    //   book: dummyBooks[index],
                    //   width: 120,
                    // );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8);
                  },
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
      ),
    );
  }
}
