import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/home_page_header.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List profileMenuItems = [
      {
        "icon": "users-solid.svg",
        "text": "Informasi Akun",
        "color": primaryTextColor,
        "onTap": () {},
      },
      {
        "icon": "question-circle-fill.svg",
        "text": "Frequently Asked Question",
        "color": primaryTextColor,
        "onTap": () {},
      },
      {
        "icon": "phone-handset-solid.svg",
        "text": "Hubungi Kami",
        "color": primaryTextColor,
        "onTap": () {},
      },
      {
        "icon": "star-solid.svg",
        "text": "Beri Rating",
        "color": primaryTextColor,
        "onTap": () {},
      },
      {
        "icon": "certificate-solid.svg",
        "text": "Sertifikat",
        "color": primaryTextColor,
        "onTap": () {},
      },
      {
        "icon": "logout-solid.svg",
        "text": "Log Out",
        "color": errorColor,
        "onTap": () {},
      },
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(
              child: Container(
                padding: const EdgeInsets.all(12.0),
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
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          navigatorKey.currentState?.pop();
                        },
                        child: Row(
                          children: [
                            SvgAsset(
                              assetPath:
                                  AssetPath.getIcon("caret-line-left.svg"),
                              color: secondaryTextColor,
                              height: 20.0,
                              width: 20.0,
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: Text(
                                "Kembali ke Beranda",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: profileMenuItems.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        width: double.infinity,
                        child: TextButton(
                          onPressed: profileMenuItems[index]["onTap"],
                          child: Row(
                            children: [
                              SvgAsset(
                                assetPath: AssetPath.getIcon(
                                    profileMenuItems[index]["icon"]),
                                color: profileMenuItems[index]["color"],
                                height: 28.0,
                                width: 28.0,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: Text(
                                  profileMenuItems[index]["text"],
                                  style: textTheme.titleMedium!.copyWith(
                                    color: profileMenuItems[index]["color"],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
