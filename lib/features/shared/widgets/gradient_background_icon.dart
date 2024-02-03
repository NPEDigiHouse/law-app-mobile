import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class GradientBackgroundIcon extends StatelessWidget {
  final double size;
  final String icon;

  const GradientBackgroundIcon({
    super.key,
    required this.size,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: GradientColors.redPastel,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SvgAsset(
        color: scaffoldBackgroundColor,
        assetPath: AssetPath.getIcon(icon),
      ),
    );
  }
}