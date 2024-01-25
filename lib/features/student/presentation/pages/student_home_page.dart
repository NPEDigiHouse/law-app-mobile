// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/common/widget/book_item.dart';
import 'package:law_app/features/common/widget/course_item_card.dart';
import 'package:law_app/features/common/widget/home_page_discussion_card.dart';
import 'package:law_app/features/common/widget/home_page_header.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late final List dashboardItems;
  late final List carouselItems;
  late final List homePageDiscussionItems;
  late final List booksItems;
  late final List courseItems;

  @override
  void initState() {
    super.initState();

    dashboardItems = [
      {
        "icon": "chalkboard-teacher-fill.svg",
        "count": 2,
        "text": "Course Diambil",
      },
      {
        "icon": "question-circle-line.svg",
        "count": 20,
        "text": "Pertanyaan Saya",
      },
      {
        "icon": "book-bold.svg",
        "count": 9,
        "text": "Buku yang Dibaca",
      },
    ];

    carouselItems = [
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

    courseItems = [
      {
        "img": "sample-course-image.jpg",
        "title": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing",
        "completionTime": 48.8,
        "isActive": true,
        "totalStudent": 100,
        "rating": 5.0,
      },
      {
        "img": "sample-course-image.jpg",
        "title": "Tips Menerjemahkan",
        "completionTime": 48.8,
        "isActive": false,
        "totalStudent": 150,
        "rating": 0.0,
      },
      {
        "img": "sample-course-image.jpg",
        "title": "Tips Menerjemahkan Dokumen",
        "completionTime": 48.8,
        "isActive": true,
        "totalStudent": 110,
        "rating": 3.5,
      },
    ];
  }

  @override
  void dispose() {
    super.dispose();

    carouselItems;
    homePageDiscussionItems;
    booksItems;
    courseItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(dashboardItem: dashboardItems),
            const SizedBox(
              height: 100.0,
            ),
            CustomCarouselWithIndicator(carouselItem: carouselItems),
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
                        "Sedang Hangat",
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
                        "Popular Course",
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
                    "Buruan daftar di berbagai course yang ada untuk meningkatkan pengetahuanmu tentang hukum!",
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
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
                        child: CourseItemCard(courseItem: courseItems[index]),
                      );
                    },
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


class CustomCarouselWithIndicator extends StatefulWidget {
  const CustomCarouselWithIndicator({
    super.key,
    required this.carouselItem,
  });

  final List carouselItem;

  @override
  State<CustomCarouselWithIndicator> createState() =>
      _CustomCarouselWithIndicatorState();
}

class _CustomCarouselWithIndicatorState
    extends State<CustomCarouselWithIndicator> {
  late final ValueNotifier<int> carouselIndex;
  @override
  void initState() {
    super.initState();

    carouselIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    super.dispose();

    carouselIndex.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.carouselItem.map((e) {
            return Builder(builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AssetPath.getImage(e["img"]),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(18, 244, 133, 125),
                        Color.fromARGB(115, 31, 6, 4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e["text"],
                          style: textTheme.titleLarge!.copyWith(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }).toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) => carouselIndex.value = index,
            viewportFraction: 1.0,
            height: 160.0,
            autoPlay: true,
            autoPlayInterval: const Duration(milliseconds: 3000),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.carouselItem.length, (index) {
            return ValueListenableBuilder(
              builder: (context, carouselIndex, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: carouselIndex == index
                        ? primaryColor
                        : secondaryTextColor,
                  ),
                );
              },
              valueListenable: carouselIndex,
            );
          }),
        ),
      ],
    );
  }
}
