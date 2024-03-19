// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/reference/providers/contact_us_provider.dart';
import 'package:law_app/features/admin/presentation/reference/widgets/edit_contact_us_dialog.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ContactUsPage extends ConsumerWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (contact) {
        if (contact == null) return const Scaffold();

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Hubungi Kami',
              withBackButton: true,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hubungi Kami',
                  style: textTheme.headlineMedium!.copyWith(
                    color: primaryColor,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 16),
                buildContactCard(
                  icon: 'whatsapp-fill.svg',
                  contact: 'WhatsApp',
                  name: '${contact.whatsappLink}',
                  onPressed: () async {
                    final url =
                        Uri.parse('https://wa.me/${contact.whatsappLink}');

                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                ),
                const SizedBox(height: 8),
                buildContactCard(
                  icon: 'envelope-solid.svg',
                  contact: 'Email',
                  name: '${contact.emailLink}',
                  onPressed: () async {
                    final url = Uri.parse('mailto:${contact.emailLink}');

                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                ),
                const SizedBox(height: 8),
                buildContactCard(
                  icon: 'map-marker-solid.svg',
                  contact: 'Alamat',
                  name: '${contact.addressName}',
                  onPressed: () async {
                    final url = Uri.parse('${contact.addressLink}');

                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: CredentialSaver.user!.role == 'admin'
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
                      builder: (_) => EditContactUsDialog(contact: contact),
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

  Container buildContactCard({
    required String icon,
    required String contact,
    required String name,
    required VoidCallback onPressed,
  }) {
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
            icon: icon,
            size: 64,
            padding: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact,
                  style: textTheme.titleMedium,
                ),
                Text(
                  name,
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
              onPressed: onPressed,
              icon: SvgAsset(
                assetPath: AssetPath.getIcon("caret-line-right.svg"),
                color: primaryColor,
                width: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
