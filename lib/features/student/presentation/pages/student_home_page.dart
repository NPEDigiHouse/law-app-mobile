import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/common/shared/svg_asset.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List dashboardItem = [
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

  List carouselItem = [
    {"img": "sample_carousel_image1.jpg", "text": "Promo Mingguan 1"},
    {"img": "sample_carousel_image2.jpg", "text": "Promo Mingguan 2"},
    {"img": "sample_carousel_image3.jpg", "text": "Promo Mingguan 3"},
    {"img": "sample_carousel_image4.jpg", "text": "Promo Mingguan 4"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: GradientColors.redPastel,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -20,
                    right: 20,
                    child: SvgAsset(
                      assetPath: AssetPath.getVector('app_logo_white.svg'),
                      color: tertiaryColor,
                      width: 160,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: SafeArea(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: textTheme.headlineMedium,
                                    children: [
                                      const TextSpan(
                                        text: 'Selamat Datang,\n',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400,
                                          color: scaffoldBackgroundColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${user.username}!',
                                        style: const TextStyle(
                                          color: accentTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  user.role == 1 ? "Siswa" : "Pakar",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                child: TextButton(
                                  onPressed: () {},
                                  child: SvgAsset(
                                    width: 36,
                                    height: 36,
                                    color: scaffoldBackgroundColor,
                                    assetPath: AssetPath.getIcon(
                                      "notification-solid.svg",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scaffoldBackgroundColor,
                                  border: Border.all(
                                    color: accentColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 23,
                                  foregroundImage: AssetImage(
                                    AssetPath.getImage("no-profile.jpg"),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: 20,
                    right: 20,
                    child: Dashboard(dashboardItem: dashboardItem),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100.0,
            ),
            CustomCarouselWithIndicator(carouselItem: carouselItem),
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
                    height: 8.0,
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 4.0,
                            )
                          ],
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: textTheme.titleSmall,
                            children: const [
                              TextSpan(
                                text:
                                    "Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan? \n \n",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
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
                      itemCount: 5,
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          width: 140,
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 4.0,
                            right: index == 5 ? 0 : 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                AssetPath.getImage("sample-book-cover.jpg"),
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.2),
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 4.0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12.0),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: GradientColors.redPastel,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: Center(
                                  child: Text(
                                    "The Power Of Habits",
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodySmall!.copyWith(
                                        color: scaffoldBackgroundColor,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 4.0,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: AssetImage(
                                    AssetPath.getImage(
                                        "sample-course-image.jpg"),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: GradientColors.redPastel,
                                    ),
                                    backgroundBlendMode: BlendMode.softLight),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing",
                                    maxLines: 3,
                                    style: textTheme.titleMedium!.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SvgAsset(
                                            color: secondaryTextColor,
                                            assetPath: AssetPath.getIcon(
                                                "clock-solid.svg"),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            "48 jam",
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          border: Border.all(color: infoColor),
                                        ),
                                        child: Text(
                                          "Aktif",
                                          style: textTheme.bodySmall!.copyWith(
                                            color: infoColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgAsset(
                                            color: secondaryTextColor,
                                            assetPath: AssetPath.getIcon(
                                                "users-solid.svg"),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            "3000009",
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 90,
                                        height: 16,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          padding:
                                              const EdgeInsets.all(0),
                                          scrollDirection:
                                              Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return SvgAsset(
                                              color: accentColor,
                                              assetPath:
                                                  AssetPath.getIcon(
                                                      "star-solid.svg"),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
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

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.dashboardItem,
  });

  final List dashboardItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(2.0, 2.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dashboardItem.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dashboardItem.length > 3 ? 1.0 : 12.0,
            ),
            child: SizedBox(
              width: 80.0,
              child: Column(
                children: [
                  Container(
                    height: 58.0,
                    width: 58.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      gradient: LinearGradient(
                        colors: GradientColors.redPastel,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SvgAsset(
                      color: scaffoldBackgroundColor,
                      assetPath:
                          AssetPath.getIcon(dashboardItem[index]["icon"]),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.bodyMedium!.copyWith(
                          color: primaryTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: "${dashboardItem[index]["count"]}\n",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: dashboardItem[index]["text"],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
