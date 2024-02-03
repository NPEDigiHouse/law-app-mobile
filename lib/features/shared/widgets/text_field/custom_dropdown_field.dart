import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomDropdownField extends StatefulWidget {
  final ValueNotifier<String?> selectedItem;
  final List<String> sortingItems;
  final String label;
  const CustomDropdownField({
    super.key,
    required this.sortingItems,
    required this.label,
    required this.selectedItem,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            widget.label,
            textAlign: TextAlign.left,
            style: textTheme.titleMedium!.copyWith(
              color: primaryTextColor,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        ValueListenableBuilder(
          valueListenable: widget.selectedItem,
          builder: (context, val, _) => DropdownButtonFormField<String>(
            elevation: 1,
            alignment: Alignment.bottomCenter,
            value: val,
            items: widget.sortingItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            icon: Transform.rotate(
              angle: -22.5 * math.pi,
              child: SvgAsset(
                height: 20,
                width: 20,
                color: primaryColor,
                assetPath: AssetPath.getIcon(
                  "caret-line-left.svg",
                ),
              ),
            ),
            onChanged: (value) {
              widget.selectedItem.value = value.toString();
            },
            dropdownColor: scaffoldBackgroundColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: scaffoldBackgroundColor,
              hintText: "Pilih Properti",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: secondaryTextColor),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            style: textTheme.bodyLarge!.copyWith(
              color: primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
