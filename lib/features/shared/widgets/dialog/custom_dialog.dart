import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final List<Widget> children;

  const CustomDialog({
    super.key,
    required this.title,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.primaryButtonText,
    this.secondaryButtonText,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                    child: Text(
                      title,
                      style: textTheme.titleLarge!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('close-line.svg'),
                      width: 20,
                    ),
                    tooltip: 'Kembali',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                children: children,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: onPressedSecondaryButton ??
                          () => navigatorKey.currentState!.pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                      ),
                      child: Text(secondaryButtonText ?? 'Kembali'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: onPressedPrimaryButton ??
                          () => navigatorKey.currentState!.pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(primaryButtonText ?? 'Konfirmasi'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
