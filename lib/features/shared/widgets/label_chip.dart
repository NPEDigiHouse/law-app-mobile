// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/text_style.dart';

class LabelChip extends StatelessWidget {
  final String text;
  final Color color;

  const LabelChip({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color,
        ),
      ),
      child: Text(
        text,
        style: textTheme.labelSmall!.copyWith(
          color: color,
        ),
      ),
    );
  }
}
