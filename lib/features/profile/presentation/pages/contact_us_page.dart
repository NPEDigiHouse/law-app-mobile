// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/presentation/reference/widgets/edit_contact_us_dialog.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      {
        "icon": "whatsapp-fill.svg",
        "contact": "WhatsApp",
      },
      {
        "icon": "envelope-solid.svg",
        "contact": "Email",
      },
      {
        "icon": "map-marker-solid.svg",
        "contact": "Alamat",
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: CredentialSaver.user!.role! == 'admin'
              ? "Kelola Kontak Kami"
              : "Hubungi Kami",
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ),
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
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
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
                    child: Row(
                      children: [
                        GradientBackgroundIcon(
                          icon: '${items[index]["icon"]}',
                          size: 64,
                          padding: 12,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${items[index]["contact"]}',
                                style: textTheme.titleMedium,
                              ),
                              Text(
                                'Value',
                                style: textTheme.bodyMedium!.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: secondaryColor,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: SvgAsset(
                              assetPath: AssetPath.getIcon(
                                "caret-line-right.svg",
                              ),
                              color: primaryColor,
                              width: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CredentialSaver.user!.role! == 'admin'
          ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: GradientColors.redPastel,
                ),
              ),
              child: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const EditContactUsDialog(items: items),
                ),
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon('pencil-solid.svg'),
                  color: scaffoldBackgroundColor,
                  width: 24,
                ),
                tooltip: 'Edit',
              ),
            )
          : null,
    );
  }
}
