import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/shared/profile/account_information_page.dart';
import 'package:law_app/features/shared/profile/certificate_page.dart';
import 'package:law_app/features/shared/profile/contact_us_page.dart';
import 'package:law_app/features/shared/profile/faq_page.dart';
import 'package:law_app/features/shared/widgets/home_page_header.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ProfilePage extends StatelessWidget {
  final int roleId;
  const ProfilePage({
    Key? key,
    required this.roleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List profileMenuItems = setProfileMenuItems(roleId, context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              HomePageHeader(
                isAdmin: roleId == 0,
                isProfile: true,
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
                      SizedBox(
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
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: profileMenuItems.length,
                        itemBuilder: (context, index) {
                          return Container(
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
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  List setProfileMenuItems(int roleId, BuildContext context) {
    if (roleId == 0) {
      return [
        {
          "icon": "users-solid.svg",
          "text": "Informasi Akun",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const AccountInformationPage(),
              ),
            );
          },
        },
        {
          "icon": "logout-solid.svg",
          "text": "Log Out",
          "color": errorColor,
          "onTap": () {
            context.showConfirmDialog(
              title: "Log Out",
              message: "Dengan ini, seluruh sesi Anda akan berakhir.",
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pushReplacementNamed(loginRoute);
              },
            );
          },
        },
      ];
    } else if (roleId == 1) {
      return [
        {
          "icon": "users-solid.svg",
          "text": "Informasi Akun",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const AccountInformationPage(),
              ),
            );
          },
        },
        {
          "icon": "question-circle-fill.svg",
          "text": "Frequently Asked Question",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const FAQPage(),
              ),
            );
          },
        },
        {
          "icon": "phone-handset-solid.svg",
          "text": "Hubungi Kami",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const ContactUsPage(),
              ),
            );
          },
        },
        {
          "icon": "star-solid.svg",
          "text": "Beri Rating",
          "color": primaryTextColor,
          "onTap": () {},
        },
        {
          "icon": "logout-solid.svg",
          "text": "Log Out",
          "color": errorColor,
          "onTap": () {
            context.showConfirmDialog(
              title: "Log Out",
              message: "Dengan ini, seluruh sesi Anda akan berakhir.",
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pushReplacementNamed(loginRoute);
              },
            );
          },
        },
      ];
    } else {
      return [
        {
          "icon": "users-solid.svg",
          "text": "Informasi Akun",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const AccountInformationPage(),
              ),
            );
          },
        },
        {
          "icon": "question-circle-fill.svg",
          "text": "Frequently Asked Question",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const FAQPage(),
              ),
            );
          },
        },
        {
          "icon": "phone-handset-solid.svg",
          "text": "Hubungi Kami",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const ContactUsPage(),
              ),
            );
          },
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
          "onTap": () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => const CertificatePage(),
              ),
            );
          },
        },
        {
          "icon": "logout-solid.svg",
          "text": "Log Out",
          "color": errorColor,
          "onTap": () {
            context.showConfirmDialog(
              title: "Log Out",
              message: "Dengan ini, seluruh sesi Anda akan berakhir.",
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pushReplacementNamed(loginRoute);
              },
            );
          },
        },
      ];
    }
  }
}
