// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/admin/presentation/reference/widgets/edit_contact_us_dialog.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ContactUsPage extends StatelessWidget {
  final bool isAdmin;
  const ContactUsPage({
    super.key,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    const contactUsItems = [
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: isAdmin ? "Kelola Kontak Kami" : "Hubungi Kami",
          withBackButton: true,
        ),
      ),
      floatingActionButton: isAdmin
          ? Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient:
                    const LinearGradient(colors: GradientColors.redPastel),
              ),
              child: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const EditContactUsDialog(items: contactUsItems),
                ),
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon('pencil-solid.svg'),
                  color: secondaryColor,
                  width: 32,
                ),
                tooltip: 'Kembali',
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hubungi Kami",
                style: textTheme.headlineMedium!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: contactUsItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          GradientBackgroundIcon(
                            icon: contactUsItems[index]["icon"]!,
                            size: 72,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contactUsItems[index]["contactName"]!,
                                  style: textTheme.titleMedium!.copyWith(
                                    color: primaryTextColor,
                                  ),
                                ),
                                Text(
                                  contactUsItems[index]["text"]!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgAsset(
                                height: 20,
                                width: 20,
                                color: primaryColor,
                                assetPath: AssetPath.getIcon(
                                  "caret-line-right.svg",
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
