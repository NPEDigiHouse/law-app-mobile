import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class TypeSelectorDialog extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items; // properti Map-nya: {"text", "onTap"}

  const TypeSelectorDialog({
    super.key,
    required this.title,
    required this.items,
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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: List<Padding>.generate(
                items.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWellContainer(
                    color: secondaryColor,
                    radius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onTap: items[index]["onTap"],
                    child: Center(
                      child: Text(
                        items[index]["text"],
                        style: textTheme.titleMedium!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
