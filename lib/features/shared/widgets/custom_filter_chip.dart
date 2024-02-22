// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      labelStyle: textTheme.bodySmall!.copyWith(
        color: selected ? primaryColor : primaryTextColor,
        letterSpacing: 0,
      ),
      side: selected
          ? const BorderSide(color: primaryColor)
          : const BorderSide(color: secondaryTextColor),
      selectedColor: secondaryColor,
      backgroundColor: scaffoldBackgroundColor,
      clipBehavior: Clip.antiAlias,
    );
  }
}
