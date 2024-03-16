// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/ad/pages/admin_ad_form_page.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_detail_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class AdDetailPage extends ConsumerWidget {
  final bool isAdmin;
  final int id;
  const AdDetailPage({
    super.key,
    required this.id,
    this.isAdmin = false,
  });

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Ad Detail',
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: "pencil-solid.svg",
          trailingButtonTooltip: "edit",
          onPressedTrailingButton: () => navigatorKey.currentState!.pushNamed(
            adminAdFromRoute,
            arguments: AdminAdFormPageArgs(
              title: "Edit Ad",
              ad: ad.value,
            ),
          ),
        ),
      ),
      body: ad.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (ad) {
          if (ad == null) return null;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 130),
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: ad.imageName!,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(0, 228, 77, 66),
                                Color.fromARGB(150, 244, 133, 125),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ad.title!,
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ad.content!,
                      )
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

class AdDetailPageArgs {
  final int id;
  final bool isAdmin;

  const AdDetailPageArgs({
    required this.id,
    this.isAdmin = false,
  });
}
