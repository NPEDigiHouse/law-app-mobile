// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:app_settings/app_settings.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class NetworkErrorBottomSheet extends StatelessWidget {
  final VoidCallback? onPressedPrimaryButton;

  const NetworkErrorBottomSheet({
    super.key,
    this.onPressedPrimaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          SvgAsset(
            assetPath: AssetPath.getVector('error-lost-in-space-cuate.svg'),
            width: 250,
          ),
          Text(
            'Internet kamu terputus!',
            style: textTheme.headlineSmall!.copyWith(
              fontSize: 22,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Harap periksa koneksi internet atau Wi-fi dan coba lagi.',
            style: textTheme.bodySmall!.copyWith(
              color: const Color(0xFF737373),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => AppSettings.openAppSettings(
                    type: AppSettingsType.device,
                  ),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: secondaryColor,
                    foregroundColor: primaryColor,
                  ),
                  child: const Text('Lihat Pengaturan'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: onPressedPrimaryButton ??
                      () => navigatorKey.currentState!.pop(),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
