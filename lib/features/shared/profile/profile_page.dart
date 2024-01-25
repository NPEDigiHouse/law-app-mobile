import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/common/widget/svg_asset.dart';

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
                                  user.role == 0
                                      ? "Admin"
                                      : user.role == 1
                                          ? "Pakar"
                                          : "Siswa",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: accentTextColor,
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
                    top: 170,
                    left: 20,
                    right: 20,
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
                              onPressed: () {},
                              child: Row(
                                children: [
                                  SvgAsset(
                                    assetPath: AssetPath.getIcon(
                                        "caret-line-left.svg"),
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
                                          color: profileMenuItems[index]
                                              ["color"],
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
