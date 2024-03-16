// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/reference/providers/contact_us_provider.dart';
import 'package:law_app/features/admin/presentation/reference/widgets/edit_contact_us_dialog.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ContactUsPage extends ConsumerWidget {
  final bool isAdmin;

  const ContactUsPage({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> items = [];

    final contact = ref.watch(contactUsProvider);

    ref.listen(contactUsProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(contactUsProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return contact.when(
      loading: () => const LoadingIndicator(
        withScaffold: true,
      ),
      error: (_, __) => const Scaffold(),
      data: (contact) {
        if (contact == null) return Container();

        items = [
          {
            "icon": "whatsapp-fill.svg",
            "formLabel": "whatsapp",
            "contact": "WhatsApp",
            "contactName": contact.whatsappName,
            "link": contact.whatsappLink,
          },
          {
            "icon": "envelope-solid.svg",
            "formLabel": "email",
            "contact": "Email",
            "contactName": contact.emailName,
            "link": contact.emailLink,
          },
          {
            "icon": "map-marker-solid.svg",
            "formLabel": "address",
            "contact": "Alamat",
            "contactName": contact.addressName,
            "link": contact.addressLink,
          },
        ];

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: HeaderContainer(
              title: isAdmin ? "Kelola Kontak Kami" : "Hubungi Kami",
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
                                    '${items[index]["contactName"]}',
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
                                onPressed: () async {
                                  if (items[index]['contact'] == "Email") {
                                    final uri = Uri.parse(
                                      'mailto:${items[index]['link']}',
                                    );
                                    if (!await launchUrl(uri)) {
                                      throw Exception('Could not launch $uri');
                                    }
                                  } else {
                                    final uri = Uri.parse(
                                      items[index]['link'],
                                    );
                                    if (!await launchUrl(uri)) {
                                      throw Exception('Could not launch $uri');
                                    }
                                  }
                                },
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
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: isAdmin
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
                      builder: (_) => EditContactUsDialog(items: items),
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
      },
    );
  }
}
