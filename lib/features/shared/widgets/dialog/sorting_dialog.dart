import 'package:flutter/material.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_dropdown_field.dart';

class SortingDialog extends StatelessWidget {
  final String title;
  final List<String> sortingItems;
  final ValueNotifier<String?> selectedFirstDropdown;
  final ValueNotifier<String?> selectedSecondDropdown;
  final VoidCallback? onPressedPrimaryButton;
  final String? primaryButtonText;

  const SortingDialog({
    super.key,
    required this.title,
    required this.sortingItems,
    required this.selectedFirstDropdown,
    required this.selectedSecondDropdown,
    this.onPressedPrimaryButton,
    this.primaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      onPressedPrimaryButton: onPressedPrimaryButton,
      primaryButtonText: primaryButtonText,
      children: [
        CustomDropdownField(
          label: "Urut Berdasarkan",
          items: sortingItems,
          selectedItem: selectedFirstDropdown,
        ),
        const SizedBox(height: 24),
        CustomDropdownField(
          label: "Urut Secara",
          items: const ["Ascending", "Descending"],
          selectedItem: selectedSecondDropdown,
        ),
      ],
    );
  }
}
