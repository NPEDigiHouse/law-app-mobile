import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/shared/widgets/home_page_header.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ProfilePage extends StatelessWidget {
  final int roleId;

  const ProfilePage({super.key, required this.roleId});

  @override
  Widget build(BuildContext context) {
    final profileMenuItems = setProfileMenuItems(context, roleId);

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
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => navigatorKey.currentState?.pop(),
                          child: Row(
                            children: [
                              SvgAsset(
                                assetPath: AssetPath.getIcon(
                                  "caret-line-left.svg",
                                ),
                                color: secondaryTextColor,
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 16),
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
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: profileMenuItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: TextButton(
                              onPressed: profileMenuItems[index]["onTap"],
                              child: Row(
                                children: [
                                  SvgAsset(
                                    assetPath: AssetPath.getIcon(
                                      profileMenuItems[index]["icon"],
                                    ),
                                    color: profileMenuItems[index]["color"],
                                    height: 28,
                                    width: 28,
                                  ),
                                  const SizedBox(width: 16),
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

  List<Map<String, dynamic>> setProfileMenuItems(
    BuildContext context,
    int roleId,
  ) {
    if (roleId == 0) {
      return [
        {
          "icon": "users-solid.svg",
          "text": "Informasi Akun",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.pushNamed(accountInfoRoute);
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
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
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
            navigatorKey.currentState!.pushNamed(accountInfoRoute);
          },
        },
        {
          "icon": "question-circle-fill.svg",
          "text": "Frequently Asked Question",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.pushNamed(faqRoute);
          },
        },
        {
          "icon": "phone-handset-solid.svg",
          "text": "Hubungi Kami",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.pushNamed(contactUsRoute);
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
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
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
            navigatorKey.currentState!.pushNamed(accountInfoRoute);
          },
        },
        {
          "icon": "question-circle-fill.svg",
          "text": "Frequently Asked Question",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.pushNamed(faqRoute);
          },
        },
        {
          "icon": "phone-handset-solid.svg",
          "text": "Hubungi Kami",
          "color": primaryTextColor,
          "onTap": () {
            navigatorKey.currentState!.pushNamed(contactUsRoute);
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
            navigatorKey.currentState!.pushNamed(certificateRoute);
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
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
            );
          },
        },
      ];
    }
  }
}
