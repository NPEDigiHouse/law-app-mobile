// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';

// Project imports:
import 'package:law_app/core/configs/app_configs.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with AfterLayoutMixin<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgAsset(
                    assetPath: AssetPath.getVector('app_logo.svg'),
                    width: 160,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: textTheme.headlineSmall,
                      children: const [
                        TextSpan(
                          text: 'Sobat\t',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: tertiaryColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Hukum',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Text(
                "Version ${AppConfigs.version}",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      navigatorKey.currentState!.pushReplacementNamed(wrapperRoute);
    });
  }
}