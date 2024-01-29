import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_app_bar.dart';
import 'package:law_app/features/shared/widgets/icon_with_gradient_background.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List contactUsItems = [
      {
        "icon": "whatsapp-fill.svg",
        "contactName": "WhatsApp",
        "text": "082910291823",
      },
      {
        "icon": "envelope-solid.svg",
        "contactName": "Email",
        "text": "sobathukumapp@gmail.com",
      },
      {
        "icon": "map-marker-solid.svg",
        "contactName": "Alamat",
        "text": "Jl. Perintis Kemerdekaan KM.15",
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Hubungi Kami",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hubungi Kami",
                style: textTheme.headlineMedium!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: contactUsItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
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
                      child: Row(
                        children: [
                          IconWithGradientBackground(
                            icon: contactUsItems[index]["icon"],
                            size: 72,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contactUsItems[index]["contactName"],
                                  style: textTheme.titleMedium!.copyWith(
                                    color: primaryTextColor,
                                  ),
                                ),
                                Text(
                                  contactUsItems[index]["text"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Transform.rotate(
                                angle: -45 * math.pi,
                                child: SvgAsset(
                                  height: 20.0,
                                  width: 20.0,
                                  color: primaryColor,
                                  assetPath:
                                      AssetPath.getIcon("caret-line-left.svg"),
                                ),
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
}
