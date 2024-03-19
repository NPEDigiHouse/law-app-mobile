// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';
import 'package:law_app/features/admin/presentation/ad/providers/ad_actions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdCard extends ConsumerWidget {
  final AdModel ad;

  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      color: scaffoldBackgroundColor,
      radius: 12,
      padding: const EdgeInsets.all(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(1, 1),
          blurRadius: 4,
        ),
      ],
      onTap: () => navigatorKey.currentState!.pushNamed(
        adDetailRoute,
        arguments: ad.id,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomNetworkImage(
              imageUrl: ad.imageName!,
              placeHolderSize: 24,
              aspectRatio: 1,
              radius: 8,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${ad.title}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: errorColor,
                  ),
                  child: IconButton(
                    onPressed: () => context.showConfirmDialog(
                      title: "Hapus FAQ?",
                      message: "Apakah Anda yakin ingin menghapus FAQ ini?",
                      onPressedPrimaryButton: () {
                        navigatorKey.currentState!.pop();

                        ref
                            .read(adActionsProvider.notifier)
                            .deleteAd(id: ad.id!);
                      },
                    ),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('trash-solid.svg'),
                      color: scaffoldBackgroundColor,
                      width: 24,
                    ),
                    tooltip: 'Hapus',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
