import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/common/widgets/svg_asset.dart';

/// A collection of widget utility functions that are reusable for this app
class WidgetUtils {
  /// Create a custom [MaterialBanner] widget.
  static MaterialBanner createMaterialBanner({
    required String contentText,
    String? leadingIconName,
    Color? foregroundColor,
    Color? backgroundColor,
    bool autoClose = true,
    Duration autoCloseDuration = const Duration(milliseconds: 3500),
    bool showOkButton = false,
  }) {
    return MaterialBanner(
      elevation: 0,
      dividerColor: Colors.transparent,
      backgroundColor: backgroundColor,
      leadingPadding: const EdgeInsetsDirectional.only(end: 10.0),
      content: Text(
        contentText,
        style: TextStyle(color: foregroundColor),
      ),
      leading: leadingIconName != null
          ? SvgAsset(
              assetPath: AssetPath.getIcon(leadingIconName),
              color: foregroundColor,
              width: 20,
            )
          : null,
      actions: showOkButton
          ? [
              TextButton(
                onPressed: () => scaffoldMessengerKey.currentState!
                    .hideCurrentMaterialBanner(),
                child: Text(
                  'Ok',
                  style: TextStyle(color: foregroundColor),
                ),
              ),
            ]
          : [
              const SizedBox(),
            ],
      onVisible: autoClose
          ? () {
              Future.delayed(autoCloseDuration, () {
                scaffoldMessengerKey.currentState!.hideCurrentMaterialBanner();
              });
            }
          : null,
    );
  }
}
