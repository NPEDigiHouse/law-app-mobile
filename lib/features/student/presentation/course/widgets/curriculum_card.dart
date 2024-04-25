// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CurriculumCard extends StatelessWidget {
  final CurriculumModel curriculum;
  final bool showDetail;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  const CurriculumCard({
    super.key,
    required this.curriculum,
    this.showDetail = false,
    this.isCompleted = false,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: double.infinity,
      color: scaffoldBackgroundColor,
      radius: 10,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
      onTap: isLocked ? null : onTap,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 16,
            child: SvgAsset(
              assetPath: AssetPath.getIcon('balance-scale.svg'),
              color: isLocked ? secondaryTextColor.withOpacity(.5) : secondaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showDetail ? '${curriculum.title}' : '${curriculum.title}\n',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium!.copyWith(
                    color: isLocked ? secondaryTextColor.withOpacity(.5) : primaryColor,
                  ),
                ),
                if (showDetail) ...[
                  const SizedBox(height: 4),
                  if (isCompleted)
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: successColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Diselesaikan',
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: successColor,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        SvgAsset(
                          assetPath: AssetPath.getIcon('clock-solid.svg'),
                          color: isLocked ? secondaryTextColor.withOpacity(.5) : secondaryTextColor,
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${curriculum.curriculumDuration} menit',
                          style: textTheme.bodySmall!.copyWith(
                            color:
                                isLocked ? secondaryTextColor.withOpacity(.5) : secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
