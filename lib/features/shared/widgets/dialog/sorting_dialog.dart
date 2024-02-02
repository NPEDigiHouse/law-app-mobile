import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class SortingDialog extends StatefulWidget {
  const SortingDialog({super.key});

  @override
  State<SortingDialog> createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  late final List<String> sortingItems;
  late final ValueNotifier<String?> selectedItem;

  @override
  void initState() {
    super.initState();

    sortingItems = ["Username", "Nama Lengkap", "Tanggal Lahir"];

    selectedItem = ValueNotifier(sortingItems.first);
  }

  @override
  void dispose() {
    super.dispose();

    selectedItem.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Pengurutan",
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Urut Berdasarkan",
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
          valueListenable: selectedItem,
          builder: (context, val, _) => DropdownButtonFormField<String>(
            elevation: 1,
            alignment: Alignment.bottomCenter,
            items: sortingItems.map((item) {
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
              selectedItem.value = value.toString();
            },
            dropdownColor: scaffoldBackgroundColor,
            decoration: InputDecoration(
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
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            "Urut Secara",
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
          valueListenable: selectedItem,
          builder: (context, val, _) => DropdownButtonFormField<String>(
            elevation: 1,
            alignment: Alignment.bottomCenter,
            items: const [
              DropdownMenuItem(
                value: "asc",
                child: Text("ASC"),
              ),
              DropdownMenuItem(
                value: "desc",
                child: Text("DESC"),
              ),
            ],
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
              selectedItem.value = value.toString();
            },
            dropdownColor: scaffoldBackgroundColor,
            decoration: InputDecoration(
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
