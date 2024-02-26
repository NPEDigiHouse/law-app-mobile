// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/auth/presentation/providers/log_out_provider.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ProfilePage extends ConsumerWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = getMenuItems(context, ref, user);

    ref.listen(logOutProvider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) => context.showBanner(
          message: '$error',
          type: BannerType.error,
        ),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: HomePageHeader(
        user: user,
        isProfile: true,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: const Offset(2, 2),
                blurRadius: 4,
                spreadRadius: -1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => navigatorKey.currentState?.pop(),
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon("caret-line-left.svg"),
                  color: secondaryTextColor,
                  height: 20,
                  width: 20,
                ),
                label: Text(
                  "Kembali ke Beranda",
                  style: textTheme.bodyMedium!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: menuItems[index]["onTap"],
                      child: Row(
                        children: [
                          SvgAsset(
                            assetPath: AssetPath.getIcon(
                              menuItems[index]["icon"],
                            ),
                            color: menuItems[index]["color"],
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              menuItems[index]["text"],
                              style: textTheme.titleSmall!.copyWith(
                                color: menuItems[index]["color"],
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
      ),
    );
  }

  List<Map<String, dynamic>> getMenuItems(
    BuildContext context,
    WidgetRef ref,
    User user,
  ) {
    final menuItems = [
      {
        "icon": "users-solid.svg",
        "text": "Informasi Akun",
        "color": primaryTextColor,
        "onTap": () {
          navigatorKey.currentState!.pushNamed(
            accountInfoRoute,
            arguments: user,
          );
        },
      },
      {
        "icon": "question-circle-fill.svg",
        "text": "Frequently Asked Question",
        "color": primaryTextColor,
        "onTap": () {
          navigatorKey.currentState!.pushNamed(
            faqRoute,
            arguments: false,
          );
        },
      },
      {
        "icon": "phone-handset-solid.svg",
        "text": "Hubungi Kami",
        "color": primaryTextColor,
        "onTap": () {
          navigatorKey.currentState!.pushNamed(
            contactUsRoute,
            arguments: false,
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
          navigatorKey.currentState!.pushNamed(certificateRoute);
        },
      },
      {
        "icon": "logout-solid.svg",
        "text": "Log Out",
        "color": errorColor,
        "onTap": () {
          context.showConfirmDialog(
            title: "Log Out?",
            message: "Dengan ini, seluruh sesi Anda akan berakhir.",
            onPressedPrimaryButton: () {
              ref.read(logOutProvider.notifier).logOut();
            },
          );
        },
      },
    ];

    if (user.role == 'admin') {
      return [menuItems.first, menuItems.last];
    }

    if (user.role == 'teacher') {
      return [...menuItems.sublist(0, 4), menuItems.last];
    }

    return menuItems;
  }
}
