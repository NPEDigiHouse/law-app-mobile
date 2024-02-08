import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AnimatedFloatingActionButton extends StatelessWidget {
  final AnimationController fabAnimationController;
  final ScrollController scrollController;

  const AnimatedFloatingActionButton({
    super.key,
    required this.fabAnimationController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: fabAnimationController,
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton.small(
        onPressed: () => scrollController.jumpTo(0),
        elevation: 2,
        backgroundColor: secondaryColor,
        tooltip: 'Kembali ke atas',
        child: SvgAsset(
          assetPath: AssetPath.getIcon('caret-line-up.svg'),
          color: primaryColor,
          width: 20,
        ),
      ),
    );
  }
}
