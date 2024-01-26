// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/custom_app_bar.dart';
import 'package:law_app/features/shared/widgets/icon_with_gradient_background.dart';
import 'package:law_app/features/shared/ads/ads_detail_page.dart';

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
              builder: (_) => const AdsDetailPage(
                adsItem: {
                  "type": "ads",
                  "title":
                      "Dapatkan Promo Menarik Pertanyaan Khusus Unlimited!",
                  "meta": "Klik untuk selengkapnya!",
                  "description": """ 
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. 
            
            Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis. Donec auctor fermentum metus id volutpat. Ut aliquam enim ac lacus sagittis, 
            
            quis maximus dolor pretium. Pellentesque ac iaculis elit. In luctus nec eros quis pretium. Cras ante ipsum. 
            """,
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
