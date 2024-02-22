// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';
import 'package:law_app/features/shared/widgets/text_field/custom_dropdown_field.dart';

class SortingDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final sortingOrders = {'asc': 'Meningkat', 'desc': 'Menurun'};

    return CustomDialog(
      title: title,
      primaryButtonText: primaryButtonText,
      onPressedPrimaryButton: () => submit(formKey),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomDropdownField(
              isSmall: true,
              name: 'sortBy',
              label: 'Urut Berdasarkan',
              items: items,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            CustomDropdownField(
              isSmall: true,
              name: 'type',
              label: 'Urut Secara',
              items: sortingOrders.values.toList(),
              values: sortingOrders.keys.toList(),
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    if (onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.saveAndValidate()) {
        onSubmitted!(formKey.currentState!.value);
      }
    }
  }
}
