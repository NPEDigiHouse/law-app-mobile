// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class SpecificDiscussionInfoDialog extends StatelessWidget {
  const SpecificDiscussionInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Pertanyaan Khusus',
      showPrimaryButton: false,
      child: RichText(
        text: TextSpan(
          style: textTheme.bodyMedium,
          children: [
            const TextSpan(
              text:
                  'Jika dirasa perlu, Admin akan melemparkan pertanyaan ke Pakar dan menjadi\t',
            ),
            TextSpan(
              text: 'Pertanyaan Khusus.',
              style: textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
