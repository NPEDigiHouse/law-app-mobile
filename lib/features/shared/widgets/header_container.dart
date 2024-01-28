import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class HeaderContainer extends StatelessWidget {
  final bool withBackButton;
  final double? height;
  final String? title;
  final Widget? child;

  const HeaderContainer({
    super.key,
    this.withBackButton = false,
    this.height,
    this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
            top: child != null ? -20 : -40,
            right: 20,
            child: SvgAsset(
              assetPath: AssetPath.getVector('app_logo_white.svg'),
              color: tertiaryColor,
              width: 160,
            ),
          ),
          if (withBackButton)
            Positioned(
              top: 30,
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
                    padding: EdgeInsets.zero,
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('caret-line-left.svg'),
                      color: primaryColor,
                      width: 24,
                    ),
                    tooltip: 'Back',
                  ),
                ),
              ),
            ),
          if (title != null)
            Positioned(
              top: 36,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Text(
                    title!,
                    style: textTheme.titleLarge!.copyWith(
                      color: scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          if (child != null)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: child,
              ),
            ),
        ],
      ),
    );
  }
}
