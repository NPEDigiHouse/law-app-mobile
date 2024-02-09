import 'package:flutter/material.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/dialog/custom_dialog.dart';

class SpecificQuestionInfoDialog extends StatelessWidget {
  const SpecificQuestionInfoDialog({super.key});

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
                  'Jika dirasa perlu, Admin akan melemparkan pertanyaan kamu ke Pakar kami dan menjadi\t',
            ),
            TextSpan(
              text: 'Pertanyaan Khusus.',
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
