import 'package:flutter/material.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_dropdown_field.dart';

class SortingDialog extends StatefulWidget {
  final String title;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final List<String> sortingItems;
  final ValueNotifier<String?> selectedFirstDropdown;
  final ValueNotifier<String?> selectedSecondDropdown;

  const SortingDialog({
    super.key,
    required this.title,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.primaryButtonText,
    this.secondaryButtonText, required this.sortingItems, required this.selectedFirstDropdown, required this.selectedSecondDropdown,
  });

  @override
  State<SortingDialog> createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Pengurutan",
      onPressedPrimaryButton: widget.onPressedPrimaryButton,
      onPressedSecondaryButton: widget.onPressedSecondaryButton,
      children: [
        CustomDropdownField(
          label: "Urut Berdasarkan",
          sortingItems: widget.sortingItems,
          selectedItem: widget.selectedFirstDropdown,
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 4,
        ),
        CustomDropdownField(
          label: "Urut Secara",
          sortingItems: const ["ASC", "DESC"],
          selectedItem: widget.selectedSecondDropdown,
        ),
      ],
    );
  }
}
