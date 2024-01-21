import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/common/widgets/shared/svg_asset.dart';

class PrimaryHeader extends StatelessWidget {
  final bool withBackButton;

  const PrimaryHeader({
    super.key,
    this.withBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: withBackButton ? 305 : 285,
      width: double.infinity,
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
            top: -20,
            right: 20,
            child: SvgAsset(
              assetPath: AssetPath.getVector('app_logo_white.svg'),
              color: tertiaryColor,
              width: 160,
            ),
          ),
          Positioned(
            top: withBackButton ? 20 : 75,
            left: 20,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (withBackButton) ...[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: secondaryColor,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.back(),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('caret-line-left.svg'),
                          color: primaryColor,
                          width: 24,
                        ),
                        tooltip: 'Back',
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SvgAsset(
                    assetPath: AssetPath.getVector('app_logo_white.svg'),
                    width: 80,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: textTheme.headlineMedium,
                      children: const [
                        TextSpan(
                          text: 'Selamat Datang,\n',
                          style: TextStyle(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Sobat Hukum!',
                          style: TextStyle(
                            color: accentTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
