// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class EmptyContentText extends StatelessWidget {
  final String text;

  const EmptyContentText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall!.copyWith(
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
