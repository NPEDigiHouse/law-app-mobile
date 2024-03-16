// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/ad/pages/admin_ad_form_page.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/delete_ad_provider.dart';
import 'package:law_app/features/common/ad_detail_page.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminAdHomePage extends ConsumerWidget {
  const AdminAdHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ads = ref.watch(adProvider);

    ref.listen(adProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(adProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(deleteAdProvider, (_, state) {
      state.when(
        loading: () => context.showLoadingDialog(),
        error: (error, _) {
          navigatorKey.currentState!.pop();
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(adProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
            ref.invalidate(adProvider);
          }
        },
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();

            ref.invalidate(adProvider);

            context.showBanner(
              message: 'Berhasil Menghapus Ad!',
              type: BannerType.success,
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Kelola Ads',
          withBackButton: true,
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(colors: GradientColors.redPastel),
        ),
        child: IconButton(
          onPressed: () => navigatorKey.currentState!.pushNamed(
            adminAdFromRoute,
            arguments: AdminAdFormPageArgs(
              title: "Tambah Ad",
            ),
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: secondaryColor,
            width: 32,
          ),
          tooltip: 'Kembali',
        ),
      ),
      body: ads.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (ads) {
          if (ads == null) return null;

          if (ads.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Belum ada data',
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: List.generate(
                  ads.length,
                  (index) => InkWellContainer(
                    onTap: () => navigatorKey.currentState!.pushNamed(
                      adDetailRoute,
                      arguments: AdDetailPageArgs(id: ads[index].id!),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    color: scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                    radius: 12,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ads[index].imageName != null
                                          ? CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: ads[index].imageName!,
                                            )
                                          : Image.asset(
                                              AssetPath.getImage(
                                                'no-image.jpg',
                                              ),
                                            ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(37, 244, 133, 125),
                                            Color.fromARGB(75, 228, 77, 66),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Text(
                                  ads[index].title!,
                                  maxLines: 2,
                                  style: textTheme.titleMedium!,
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
                            borderRadius: BorderRadius.circular(8),
                            color: errorColor,
                          ),
                          child: IconButton(
                            onPressed: () => context.showConfirmDialog(
                              title: "Hapus FAQ",
                              message:
                                  "Apakah Anda yakin ingin menghapus FAQ ini?",
                              onPressedPrimaryButton: () {
                                navigatorKey.currentState!.pop();
                                ref
                                    .read(deleteAdProvider.notifier)
                                    .deleteAd(id: ads[index].id!);
                              },
                            ),
                            icon: SvgAsset(
                              assetPath: AssetPath.getIcon('trash-solid.svg'),
                              color: secondaryColor,
                              width: 32,
                            ),
                            tooltip: 'Hapus',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
