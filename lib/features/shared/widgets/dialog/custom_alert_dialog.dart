// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? checkboxLabel;
  final bool isError;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isError,
    this.checkboxLabel,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.primaryButtonText,
    this.secondaryButtonText,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  late final ValueNotifier<bool> isChecked;

  @override
  void initState() {
    super.initState();

    isChecked = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isChecked.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.none,
      elevation: 0,
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: 0,
                  child: Padding(
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
                ),
                Positioned(
                  top: -50,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: widget.isError ? secondaryColor : warningColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgAsset(
                      width: 100,
                      height: 100,
                      color: widget.isError ? errorColor : scaffoldBackgroundColor,
                      assetPath:
                          AssetPath.getIcon("exclamation-circle-line.svg"),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall!.copyWith(
                    color: widget.isError ? errorColor : warningColor,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  widget.message,
                  style: textTheme.bodyMedium!.copyWith(
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                if (widget.checkboxLabel != null)
                  ValueListenableBuilder(
                    valueListenable: isChecked,
                    builder: (context, val, child) => ListTileTheme(
                      minVerticalPadding: 0,
                      child: CheckboxListTile(
                        title: Text(
                          widget.checkboxLabel!,
                          style: textTheme.bodyMedium!.copyWith(
                            color: primaryTextColor,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        value: val,
                        onChanged: (bool? value) => isChecked.value = value!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: widget.onPressedSecondaryButton ?? () => navigatorKey.currentState!.pop(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: secondaryColor,
                      foregroundColor: primaryColor,
                    ),
                    child: Text(widget.secondaryButtonText ?? 'Kembali'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: widget.onPressedPrimaryButton ??
                          () => navigatorKey.currentState!.pop(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Text(widget.primaryButtonText ?? 'Konfirmasi'),
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
