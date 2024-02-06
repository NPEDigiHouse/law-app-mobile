import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueNotifier<String?> selectedItem;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: textTheme.titleMedium!.copyWith(
              color: primaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder(
          valueListenable: selectedItem,
          builder: (context, value, child) {
            return DropdownButtonFormField<String>(
              elevation: 1,
              alignment: Alignment.bottomCenter,
              value: value,
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              icon: SvgAsset(
                assetPath: AssetPath.getIcon("caret-line-down.svg"),
                color: primaryColor,
                height: 20,
                width: 20,
              ),
              onChanged: (value) => selectedItem.value = value.toString(),
              dropdownColor: scaffoldBackgroundColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: scaffoldBackgroundColor,
                hintText: "Pilih Properti",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: secondaryTextColor,
                  ),
                ),
              ),
              style: textTheme.bodyLarge!.copyWith(
                color: primaryTextColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
