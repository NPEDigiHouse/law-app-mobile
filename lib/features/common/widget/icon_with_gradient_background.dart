import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/common/widget/svg_asset.dart';

class IconWithGradientBackground extends StatelessWidget {
  final double size;
  final String icon;

  const IconWithGradientBackground({
    Key? key,
    required this.size,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        gradient: LinearGradient(
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