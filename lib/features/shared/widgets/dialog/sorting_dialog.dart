import 'package:flutter/material.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_dropdown_field.dart';

class SortingDialog extends StatelessWidget {
  final String title;
  final List<String> sortingItems;
  final ValueNotifier<String?> selectedFirstDropdown;
  final ValueNotifier<String?> selectedSecondDropdown;
  final String? primaryButtonText;
  final VoidCallback? onPressedPrimaryButton;

  const SortingDialog({
    super.key,
    required this.title,
    required this.sortingItems,
    required this.selectedFirstDropdown,
    required this.selectedSecondDropdown,
    this.primaryButtonText,
    this.onPressedPrimaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      primaryButtonText: primaryButtonText,
      onPressedPrimaryButton: onPressedPrimaryButton,
      child: Column(
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
      ),
    );
  }
}
