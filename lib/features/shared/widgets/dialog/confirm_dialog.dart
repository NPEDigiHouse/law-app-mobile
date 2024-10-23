// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/providers/manual_providers/checkbox_provider.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class ConfirmDialog extends ConsumerWidget {
  final String title;
  final String message;
  final bool withCheckbox;
  final String? checkboxLabel;
  final String? primaryButtonText;
  final VoidCallback? onPressedPrimaryButton;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.withCheckbox = false,
    this.checkboxLabel,
    this.primaryButtonText,
    this.onPressedPrimaryButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (withCheckbox) assert(checkboxLabel != null);

    final bottom = withCheckbox ? 8.0 : 16.0;
    final isChecked = ref.watch(isCheckedProvider);

    return CustomDialog(
      title: title,
      childPadding: EdgeInsets.fromLTRB(20, 8, 20, bottom),
      primaryButtonText: primaryButtonText,
      onPressedPrimaryButton: withCheckbox ? (isChecked ? onPressedPrimaryButton : null) : onPressedPrimaryButton,
      child: Column(
        children: [
          Text(message),
          if (withCheckbox) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (newValue) {
                    ref.read(isCheckedProvider.notifier).state = newValue!;
                  },
                  checkColor: scaffoldBackgroundColor,
                  side: const BorderSide(
                    color: secondaryTextColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  visualDensity: const VisualDensity(
                    vertical: VisualDensity.minimumDensity,
                    horizontal: VisualDensity.minimumDensity,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(isCheckedProvider.notifier).state = !isChecked;
                    },
                    child: Text('$checkboxLabel'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
