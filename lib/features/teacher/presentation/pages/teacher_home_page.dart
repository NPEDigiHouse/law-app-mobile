import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/book_item.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/discussion_card.dart';
import 'package:law_app/features/shared/widgets/home/home_page_header.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  late final List<Map<String, dynamic>> dashboardItems;
  late final List<Map<String, String>> booksItems;

  @override
  void initState() {
    super.initState();

    dashboardItems = [
      {
        "icon": "question-circle-line.svg",
        "count": 20,
        "text": "Pertanyaan Dijawab",
      },
      {
        "icon": "book-bold.svg",
        "count": 9,
        "text": "Buku yang Dibaca",
      },
    ];

    booksItems = [
      {
        "img": "sample-book-cover.jpg",
        "title": "Books 1",
      },
      {
        "img": "sample-book-cover.jpg",
        "title": "Books 2",
      },
      {
        "img": "sample-book-cover.jpg",
        "title": "Books 3",
      },
      {
        "img": "sample-book-cover.jpg",
        "title": "Books 4",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(
              isAdmin: false,
              isProfile: false,
              onPressedProfileIcon: () {
                navigatorKey.currentState!.pushNamed(
                  profileRoute,
                  arguments: user.roleId,
                );
              },
              child: Dashboard(
                items: dashboardItems,
              ),
            ),
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Perlu Dijawab",
                        style: textTheme.headlineSmall!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        "Lihat Lebih Banyak >",
                        style: textTheme.bodySmall!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 4,
                          bottom: index == 2 ? 0 : 4,
                        ),
                        child: DiscussionCard(
                          question: questions[index],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Buku Terbaru",
                        style: textTheme.headlineSmall!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        "Lihat Lebih Banyak >",
                        style: textTheme.bodySmall!.copyWith(
                          color: primaryTextColor,
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 4,
                            right: index == 5 ? 0 : 4,
                          ),
                          child: BookItem(
                            book: books[index],
                            width: 120,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
