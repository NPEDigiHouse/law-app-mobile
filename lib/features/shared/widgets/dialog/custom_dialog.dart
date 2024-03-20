// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry childPadding;
  final bool showPrimaryButton;
  final String? primaryButtonText;
  final VoidCallback? onPressedPrimaryButton;

  const CustomDialog({
    super.key,
    required this.title,
    required this.child,
    this.showPrimaryButton = true,
    this.childPadding = const EdgeInsets.fromLTRB(20, 12, 20, 16),
    this.primaryButtonText,
    this.onPressedPrimaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: scaffoldBackgroundColor,
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
              padding: childPadding,
              child: child,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => navigatorKey.currentState!.pop(),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                      ),
                      child: const Text('Kembali'),
                    ),
                  ),
                  if (showPrimaryButton) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: onPressedPrimaryButton,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(primaryButtonText ?? 'Konfirmasi'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
