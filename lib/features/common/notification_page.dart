// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationItems = [
      {
        "type": "discussion",
        "title": "Pertanyaan Anda telah Dijawab!",
        "meta": "Pertanyaan umum Anda telah dijawab oleh Admin.",
        "onTap": () {},
      },
      {
        "type": "course",
        "title": "Anda melewatkan Course Selama Sepekan!",
        "meta": "Klik untuk melanjutkan course Anda!",
        "onTap": () {},
      },
      {
        "type": "discussion",
        "title": "Pertanyaan Dialihkan ke Pakar",
        "meta": "Pertanyaan Anda dialihkan ke pertanyaan khusus.",
        "onTap": () {},
      },
      {
        "type": "ad",
        "title": "Dapatkan Promo Menarik, Pertanyaan Khusus Unlimited!",
        "meta": "Klik untuk selengkapnya!",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(adDetailRoute, arguments: false);
        },
      },
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Notifikasi',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              itemCount: notificationItems.length,
              itemBuilder: (context, index) {
                final type = notificationItems[index]["type"];
                final icon = type == "discussion"
                    ? "question-circle-line.svg"
                    : type == "course"
                        ? "chalkboard-teacher-fill.svg"
                        : "ads-icon.svg";

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 20,
                  ),
                  child: InkWell(
                    onTap: notificationItems[index]["onTap"] as VoidCallback,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryTextColor,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientBackgroundIcon(
                            size: 80,
                            icon: icon,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notificationItems[index]["title"] as String,
                                  style: textTheme.titleMedium!.copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  notificationItems[index]["meta"] as String,
                                ),
                              ],
                            ),
                          ),
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
