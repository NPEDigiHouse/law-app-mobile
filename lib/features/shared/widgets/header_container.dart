import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class HeaderContainer extends StatelessWidget {
  final double? height;
  final String? title;
  final bool withBackButton;
  final bool withTrailingButton;
  final String? trailingButtonIconName;
  final String? trailingButtonTooltip;
  final VoidCallback? onPressedTrailingButton;
  final Widget? child;

  const HeaderContainer({
    super.key,
    this.height,
    this.title,
    this.withBackButton = false,
    this.withTrailingButton = false,
    this.trailingButtonIconName,
    this.trailingButtonTooltip,
    this.onPressedTrailingButton,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
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
                      tooltip: 'Kembali',
                    ),
                  ),
                ),
              ),
            if (withTrailingButton)
              Builder(
                builder: (_) {
                  assert(trailingButtonIconName != null);

                  return Positioned(
                    top: 30,
                    right: 20,
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
                          onPressed: onPressedTrailingButton,
                          icon: SvgAsset(
                            assetPath: AssetPath.getIcon(
                              trailingButtonIconName!,
                            ),
                            color: primaryColor,
                            width: 24,
                          ),
                          tooltip: trailingButtonTooltip,
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (title != null)
              Positioned(
                top: 38,
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
      ),
    );
  }
}
