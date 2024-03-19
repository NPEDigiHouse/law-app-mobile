// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/ad/pages/ad_management_form_page.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_detail_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdDetailPage extends ConsumerWidget {
  final int id;

  const AdDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ad = ref.watch(AdDetailProvider(id: id));

    ref.listen(AdDetailProvider(id: id), (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(adDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ad.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (ad) {
          if (ad == null) return null;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFA2355A).withOpacity(.2),
                            const Color(0xFF730034).withOpacity(.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CustomNetworkImage(
                        imageUrl: ad.imageName!,
                        placeHolderSize: 48,
                        aspectRatio: 16 / 9,
                        fit: BoxFit.fill,
                      ),
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      foregroundColor: scaffoldBackgroundColor,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: true,
                      title: Text(
                        'Detail Ads',
                        style: textTheme.titleLarge!.copyWith(
                          color: scaffoldBackgroundColor,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () => navigatorKey.currentState!.pop(),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('caret-line-left.svg'),
                          color: scaffoldBackgroundColor,
                          width: 24,
                        ),
                        tooltip: 'Kembali',
                      ),
                      actions: [
                        if (CredentialSaver.user!.role == 'admin')
                          IconButton(
                            onPressed: () {
                              navigatorKey.currentState!.pushNamed(
                                adManagementFormRoute,
                                arguments: AdManagementFormPageArgs(
                                  title: 'Edit Ads',
                                  ad: ad,
                                ),
                              );
                            },
                            icon: SvgAsset(
                              assetPath: AssetPath.getIcon('pencil-solid.svg'),
                              color: scaffoldBackgroundColor,
                              width: 24,
                            ),
                            tooltip: 'Edit',
                          ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ad.title}',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dibuat pada ${ad.createdAt?.toStringPattern('d MMMM yyyy')}',
                        style: textTheme.labelSmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('${ad.content}')
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
