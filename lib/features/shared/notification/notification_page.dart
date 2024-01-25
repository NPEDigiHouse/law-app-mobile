// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/common/widget/icon_with_gradient_background.dart';
import 'package:law_app/features/common/widget/svg_asset.dart';
import 'package:law_app/features/shared/ads/ads_detail.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    List notificationItems = [
      {
        "type": "discussion",
        "title": "Pertanyaan Anda telah Dijawab!",
        "meta":
            "Pertanyaan umum Anda telah dijawab oleh Admin. Klik untuk selengkapnya!",
        "description": "Klik untuk selengkapnya!",
        "img": null,
        "onTap": () {},
      },
      {
        "type": "course",
        "title": "Anda melewatkan Course Selama Sepekan!",
        "meta": "Klik untuk melanjutkan Course Anda!",
        "description": "Klik untuk selengkapnya!",
        "img": null,
        "onTap": () {},
      },
      {
        "type": "discussion",
        "title": "Pertanyaan Dialihkan ke Pakar",
        "meta":
            "Pertanyaan yang Anda tanyakan sebelumnya telah dialihkan ke Pertanyaan Khusus. Klik untuk selengkapnya!",
        "description": "Klik untuk selengkapnya!",
        "img": null,
        "onTap": () {},
      },
      {
        "type": "ads",
        "title": "Dapatkan Promo Menarik Pertanyaan Khusus Unlimited!",
        "meta": "Klik untuk selengkapnya!",
        "description": """ 
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. 
            Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis. Donec auctor fermentum metus id volutpat. Ut aliquam enim ac lacus sagittis, 
            quis maximus dolor pretium. Pellentesque ac iaculis elit. In luctus nec eros quis pretium. Cras ante ipsum. 
            """,
        "img": "sample_carousel_image1.jpg",
        "onTap": () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => const AdsDetail(
                adsItem: {
                  "type": "ads",
                  "title":
                      "Dapatkan Promo Menarik Pertanyaan Khusus Unlimited!",
                  "meta": "Klik untuk selengkapnya!",
                  "description": "Klik untuk selengkapnya!",
                  "img": "sample_carousel_image1.jpg",
                },
              ),
            ),
          );
        },
      },
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 12.0,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: notificationItems.length,
              itemBuilder: (context, index) {
                String type = notificationItems[index]["type"];
                String icon = (type == "discussion")
                    ? "question-circle-line.svg"
                    : (type == "course")
                        ? "chalkboard-teacher-fill.svg"
                        : "ads-icon.svg";
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                  child: InkWell(
                    onTap: notificationItems[index]["onTap"],
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryTextColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconWithGradientBackground(size: 80, icon: icon),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notificationItems[index]["title"],
                                style: textTheme.titleMedium!.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                notificationItems[index]["meta"],
                                style: textTheme.bodyMedium!.copyWith(
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? rightIcon;

  const CustomAppBar({
    Key? key,
    this.rightIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      title: Text(
        "Notification",
        style: textTheme.headlineSmall!.copyWith(
          color: scaffoldBackgroundColor,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        height: double.infinity,
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
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            navigatorKey.currentState!.pop();
                          },
                          icon: SvgAsset(
                            height: 24.0,
                            width: 24.0,
                            color: primaryColor,
                            assetPath: AssetPath.getIcon("caret-line-left.svg"),
                          ),
                        ),
                      ),
                      (rightIcon != null)
                          ? Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgAsset(
                                  height: 24.0,
                                  width: 24.0,
                                  color: primaryColor,
                                  assetPath: AssetPath.getIcon(rightIcon!),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}
