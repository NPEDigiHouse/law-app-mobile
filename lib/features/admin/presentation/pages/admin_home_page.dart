import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const dashboardItems = [
      {
        "icon": "dictionary-book-solid.svg",
        "count": 20,
        "text": "Total\nGlosarium",
      },
      {
        "icon": "book-bold.svg",
        "count": 9,
        "text": "Total\nBuku",
      },
      {
        "icon": "user-solid.svg",
        "count": 200,
        "text": "Total\nUser",
      },
      {
        "icon": "question-circle-line.svg",
        "count": 20,
        "text": "Total\nPertanyaan",
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
              user: admin,
              isProfile: false,
              onPressedProfileIcon: () => navigatorKey.currentState!.pushNamed(
                profileRoute,
                arguments: admin.roleId,
              ),
              child: const Dashboard(
                items: dashboardItems,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 24),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 6 / 5,
                children: List<InkWellContainer>.generate(
                  menu.length,
                  (index) => InkWellContainer(
                    color: scaffoldBackgroundColor,
                    radius: 12,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        spreadRadius: -1,
                      ),
                    ],
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          padding: const EdgeInsets.all(12),
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
                        const Spacer(),
                        Row(
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
                            SvgAsset(
                              height: 18,
                              width: 18,
                              color: accentColor,
                              assetPath: AssetPath.getIcon(
                                "caret-line-right.svg",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
