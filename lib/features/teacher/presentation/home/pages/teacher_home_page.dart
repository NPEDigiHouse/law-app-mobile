// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      {
        "icon": "question-circle-line.svg",
        "count": 20,
        "text": "Pertanyaan\nDijawab",
      },
      {
        "icon": "book-bold.svg",
        "count": 9,
        "text": "Buku\nDibaca",
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 86, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Perlu Dijawab',
                          style: textTheme.titleLarge!.copyWith(
                            color: primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => navigatorKey.currentState!.pushNamed(
                          teacherDiscussionListRoute,
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
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const SizedBox();

                      // return DiscussionCard(
                      //   question: dummyQuestions[index],
                      //   role: 'teacher',
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
                    return BookItem(
                      book: dummyBooks[index],
                      width: 120,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
