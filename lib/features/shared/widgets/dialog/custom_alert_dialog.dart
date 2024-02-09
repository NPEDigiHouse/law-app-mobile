import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/checkbox_provider.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomAlertDialog extends ConsumerWidget {
  final String title;
  final String message;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool withCheckbox;
  final String? checkboxLabel;
  final String? primaryButtonText;
  final VoidCallback? onPressedPrimaryButton;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.foregroundColor,
    this.backgroundColor,
    this.withCheckbox = false,
    this.checkboxLabel,
    this.primaryButtonText,
    this.onPressedPrimaryButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (withCheckbox) assert(checkboxLabel != null);

    final isChecked = ref.watch(isCheckedProvider);

    return Dialog(
      clipBehavior: Clip.none,
      elevation: 0,
      backgroundColor: scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      assetPath: AssetPath.getIcon('close-line.svg'),
                      width: 20,
                    ),
                    tooltip: 'Kembali',
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: -50,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgAsset(
                      assetPath: AssetPath.getIcon(
                        "exclamation-circle-line.svg",
                      ),
                      color: foregroundColor ?? errorColor,
                      width: 100,
                      height: 100,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    color: foregroundColor ?? errorColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: !withCheckbox ? TextAlign.center : null,
                ),
                if (withCheckbox) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (newValue) {
                          ref.read(isCheckedProvider.notifier).state =
                              newValue!;
                        },
                        checkColor: scaffoldBackgroundColor,
                        side: const BorderSide(
                          color: secondaryTextColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        visualDensity: const VisualDensity(
                          vertical: VisualDensity.minimumDensity,
                          horizontal: VisualDensity.minimumDensity,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(isCheckedProvider.notifier).state =
                                !isChecked;
                          },
                          child: Text('$checkboxLabel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: secondaryColor,
                      foregroundColor: primaryColor,
                    ),
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: withCheckbox
                        ? (isChecked ? onPressedPrimaryButton : null)
                        : onPressedPrimaryButton,
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
    );
  }
}
