// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomInformation extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? illustrationName;
  final double size;
  final bool withScaffold;

  const CustomInformation({
    super.key,
    required this.title,
    this.subtitle,
    this.illustrationName,
    this.size = 260.0,
    this.withScaffold = false,
  });

  @override
  Widget build(BuildContext context) {
    return withScaffold
        ? Scaffold(body: buildCustomInformation())
        : buildCustomInformation();
  }

  Center buildCustomInformation() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (illustrationName != null) ...[
              SvgAsset(
                assetPath: AssetPath.getVector(illustrationName!),
                width: size,
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              style: textTheme.headlineSmall!.copyWith(
                fontSize: 22,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            if (subtitle != null)
              Text(
                subtitle!,
                style: textTheme.bodySmall!.copyWith(
                  color: const Color(0xFF737373),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
