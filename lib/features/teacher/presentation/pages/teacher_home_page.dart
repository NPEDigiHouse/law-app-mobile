import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/book_item.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/home_page_discussion_card.dart';
import 'package:law_app/features/shared/widgets/home_page_header.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  late final List dashboardItems;
  late final List homePageDiscussionItems;
  late final List booksItems;

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

    homePageDiscussionItems = [
      {
        "title": "Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?",
        "description":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac."
      },
      {
        "title": "Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?",
        "description":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac."
      },
      {
        "title": "Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?",
        "description":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac."
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
              child: Dashboard(
                dashboardItem: dashboardItems,
              ),
            ),
            const SizedBox(
              height: 80.0,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
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
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0.0 : 4.0,
                          bottom: index == 2 ? 0.0 : 4.0,
                        ),
                        child: HomePageDiscussioinCard(
                            discussionItem: homePageDiscussionItems[index]),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
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
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "Tingkatkan pengetahuanmu dengan buku-buku pilihan pakar untuk memperdalam ilmu kamu!",
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: 4,
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 4.0,
                            right: index == 5 ? 0 : 4.0,
                          ),
                          child: BookItem(book: booksItems[index]),
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
