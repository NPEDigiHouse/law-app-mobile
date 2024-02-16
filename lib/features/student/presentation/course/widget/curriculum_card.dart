import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CurriculumCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CurriculumCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: double.infinity,
      radius: 8,
      color: scaffoldBackgroundColor,
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
            padding: const EdgeInsets.all(20),
            child: Text(
              '$title\n',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium!.copyWith(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
