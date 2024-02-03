import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/home_page_header.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const dashboardItems = [
      {
        "icon": "dictionary-book-solid.svg",
        "count": 20,
        "text": "Total Kata",
      },
      {
        "icon": "book-bold.svg",
        "count": 9,
        "text": "Total Buku",
      },
      {
        "icon": "user-solid.svg",
        "count": 200,
        "text": "Total User",
      },
      {
        "icon": "question-circle-line.svg",
        "count": 20,
        "text": "Total Pertanyaan",
      },
    ];

    const menu = [
      {
        "icon": "user-solid.svg",
        "text": "Master Data",
      },
      {
        "icon": "question-circle-fill.svg",
        "text": "Kelola Pertanyaan",
      },
      {
        "icon": "chalkboard-teacher-fill.svg",
        "text": "Kelola Course",
      },
      {
        "icon": "book-bold.svg",
        "text": "Manajemen Buku",
      },
      {
        "icon": "dictionary-book-solid.svg",
        "text": "Kelola Glosarium",
      },
      {
        "icon": "link-line.svg",
        "text": "Referensi",
      },
      {
        "icon": "ads-icon.svg",
        "text": "Kelola Ads",
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(
              isAdmin: true,
              isProfile: false,
              onPressedProfileIcon: () {
                navigatorKey.currentState!.pushNamed(
                  profileRoute,
                  arguments: user.roleId,
                );
              },
              child: const Dashboard(
                items: dashboardItems,
              ),
            ),
            const SizedBox(height: 84),
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: secondaryTextColor,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 5 / 4,
                children: List<Container>.generate(
                  menu.length,
                  (index) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: secondaryColor,
                          ),
                          child: SvgAsset(
                            color: primaryColor,
                            assetPath: AssetPath.getIcon(
                              menu[index]["icon"]!,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                menu[index]["text"]!,
                                maxLines: 2,
                                style: textTheme.titleMedium!.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Transform.rotate(
                                angle: -45 * math.pi,
                                child: SvgAsset(
                                  height: 24,
                                  width: 24,
                                  color: accentColor,
                                  assetPath: AssetPath.getIcon(
                                    "caret-line-left.svg",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
