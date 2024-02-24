// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class GradientBackgroundIcon extends StatelessWidget {
  final String icon;
  final double size;
  final double padding;

  const GradientBackgroundIcon({
    super.key,
    required this.icon,
    required this.size,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: GradientColors.redPastel,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SvgAsset(
        assetPath: AssetPath.getIcon(icon),
        color: scaffoldBackgroundColor,
      ),
    );
  }
}
