// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/ad/pages/ad_management_form_page.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_actions_provider.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_provider.dart';
import 'package:law_app/features/admin/presentation/ad/widgets/ad_card.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdHomePage extends ConsumerWidget {
  const AdHomePage({super.key});

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

    ref.listen(adActionsProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();
            ref.invalidate(adProvider);

            context.showBanner(message: data, type: BannerType.success);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Kelola Ads',
          withBackButton: true,
        ),
      ),
      body: ads.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (ads) {
          if (ads == null) return null;

          if (ads.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Iklan masih kosong',
              subtitle: 'Tambahkan iklan dengan menekan tombol di bawah.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              return AdCard(ad: ads[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: ads.length,
          );
        },
      ),
      floatingActionButton: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: GradientColors.redPastel,
          ),
        ),
        child: IconButton(
          onPressed: () => navigatorKey.currentState!.pushNamed(
            adManagementFormRoute,
            arguments: const AdManagementFormPageArgs(title: 'Tambah Ads'),
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: scaffoldBackgroundColor,
            width: 24,
          ),
          tooltip: 'Tambah',
        ),
      ),
    );
  }
}
