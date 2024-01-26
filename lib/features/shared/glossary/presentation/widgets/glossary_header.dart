import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class GlossaryHeader extends StatelessWidget {
  const GlossaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: GradientColors.redPastel,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -32,
            right: 20,
            child: SvgAsset(
              assetPath: AssetPath.getVector('app_logo_white.svg'),
              color: tertiaryColor,
              width: 160,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glosarium',
                style: textTheme.headlineSmall!.copyWith(
                  color: accentTextColor,
                ),
              ),
              Text(
                'Cari definisi dari berbagai kata untuk memperkaya referensi dan pengetahuanmu!',
                style: textTheme.bodySmall!.copyWith(
                  color: backgroundColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
