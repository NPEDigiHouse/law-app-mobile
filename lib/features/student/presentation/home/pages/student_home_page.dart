import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/feature/course_card.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late final List<Map<String, dynamic>> dashboardItems;
  late final List<Map<String, String>> carouselItems;
  late final List<Map<String, dynamic>> courseItems;

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
            CustomCarouselWithIndicator(
              items: carouselItems,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          question: dummyQuestions[index],
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            studentDiscussionDetailRoute,
                            arguments: dummyQuestions[index],
                          ),
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
                            book: dummyBooks[index],
                            width: 120,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const SizedBox(height: 4),
                  Text(
                    "Buruan daftar di berbagai course yang ada untuk meningkatkan pengetahuanmu tentang hukum!",
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                        child: CourseCard(
                          item: courseItems[index],
                        ),
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
  final List<Map<String, dynamic>> items;

  const CustomCarouselWithIndicator({super.key, required this.items});

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
          items: widget.items.map((item) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AssetPath.getImage(item["img"] as String),
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["text"] as String,
                        style: textTheme.titleLarge!.copyWith(
                          color: scaffoldBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) => carouselIndex.value = index,
            viewportFraction: 1,
            height: 160,
            autoPlay: true,
            autoPlayInterval: const Duration(milliseconds: 7000),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<ValueListenableBuilder>.generate(
            widget.items.length,
            (index) => ValueListenableBuilder(
              valueListenable: carouselIndex,
              builder: (context, carouselIndex, child) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: carouselIndex == index
                        ? primaryColor
                        : secondaryTextColor,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
