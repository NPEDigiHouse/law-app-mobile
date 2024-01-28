import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomIconButton extends StatelessWidget {
  final String iconName;
  final Color color;
  final double size;
  final double splashRadius;
  final String tooltip;
  final VoidCallback? onPressed;

  const CustomIconButton({
    super.key,
    required this.iconName,
    required this.color,
    required this.size,
    this.splashRadius = 4.0,
    this.tooltip = '',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: Padding(
              padding: EdgeInsets.all(splashRadius),
              child: SvgAsset(
                assetPath: AssetPath.getIcon(iconName),
                color: color,
                width: size,
                height: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
