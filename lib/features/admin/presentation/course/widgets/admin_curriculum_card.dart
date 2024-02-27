// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCurriculumCard extends StatelessWidget {
  final Curriculum curriculum;
  final bool showDetail;
  final VoidCallback? onTap;
  const AdminCurriculumCard({
    super.key,
    required this.curriculum,
    required this.showDetail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: double.infinity,
      color: scaffoldBackgroundColor,
      radius: 8,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 16,
            child: SvgAsset(
              assetPath: AssetPath.getIcon('balance-scale.svg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showDetail ? curriculum.title : '${curriculum.title}\n',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (showDetail) ...[
                        Row(
                          children: [
                            SvgAsset(
                              assetPath: AssetPath.getIcon('clock-solid.svg'),
                              color: secondaryTextColor,
                              width: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${curriculum.completionTime} Menit',
                              style: textTheme.bodySmall!.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
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
                      title: "Hapus Kurikulum",
                      message:
                          "Apakah Anda yakin ingin menghapus Kurikulum ini?",
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
        ],
      ),
    );
  }
}
