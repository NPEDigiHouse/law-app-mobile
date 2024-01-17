import 'dart:async';
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/settings/app_settings.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        navigatorKey.currentState!.pushReplacementNamed(loginRoute);
      }
    });
  }

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
                "Version ${AppSettings.appVersion}",
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
}
