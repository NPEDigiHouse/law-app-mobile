import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_dropdown_field.dart';

class SortingDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? primaryButtonText;
  final void Function(Map<String, dynamic> value)? onSubmitted;

  const SortingDialog({
    super.key,
    required this.title,
    required this.items,
    this.primaryButtonText,
    this.onSubmitted,
  });

  @override
  State<SortingDialog> createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  late final Map<String, String> sortingOrders;
  late final ValueNotifier<String> selectedFirstItem;
  late final ValueNotifier<String> selectedSecondItem;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    sortingOrders = {'asc': 'Meningkat', 'desc': 'Menurun'};
    selectedFirstItem = ValueNotifier(widget.items.first);
    selectedSecondItem = ValueNotifier(sortingOrders.values.first);
  }

  @override
  void dispose() {
    super.dispose();

    selectedFirstItem.dispose();
    selectedSecondItem.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: widget.title,
      primaryButtonText: widget.primaryButtonText,
      onPressedPrimaryButton: () => onPressedPrimaryButton(formKey),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomDropdownField(
              isSmall: true,
              name: 'sortBy',
              label: 'Urut Berdasarkan',
              items: widget.items,
              onChanged: (newValue) => selectedFirstItem.value = newValue!,
            ),
            const SizedBox(height: 16),
            CustomDropdownField(
              isSmall: true,
              name: 'type',
              label: 'Urut Secara',
              items: sortingOrders.values.toList(),
              values: sortingOrders.keys.toList(),
              onChanged: (newValue) => selectedSecondItem.value = newValue!,
            ),
          ],
        ),
      ),
    );
  }

  void onPressedPrimaryButton(GlobalKey<FormBuilderState> formKey) {
    if (widget.onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.saveAndValidate()) {
        widget.onSubmitted!(formKey.currentState!.value);
      }
    }
  }
}
