import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class SecondaryHeader extends StatelessWidget {
  final bool withBackButton;

  const SecondaryHeader({
    super.key,
    this.withBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20,
            right: 20,
            child: SvgAsset(
              assetPath: AssetPath.getVector('app_logo_white.svg'),
              color: secondaryColor,
              width: 160,
            ),
          ),
          if (withBackButton)
            Positioned(
              top: 20,
              left: 20,
              child: SafeArea(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: secondaryColor,
                  ),
                  child: IconButton(
                    onPressed: () => context.back(),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('caret-line-left.svg'),
                      color: primaryColor,
                      width: 24,
                    ),
                    tooltip: 'Kembali',
                  ),
                ),
              ),
            ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SvgAsset(
                assetPath: AssetPath.getVector('app_logo.svg'),
                width: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
