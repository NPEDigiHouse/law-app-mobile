// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class OptionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const OptionCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: double.infinity,
      color: selected ? primaryColor : scaffoldBackgroundColor,
      radius: 12,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      onTap: () => onSelected(!selected),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Text(
          label,
          style: textTheme.bodyLarge!.copyWith(
            color: selected ? scaffoldBackgroundColor : primaryColor,
          ),
        ),
      ),
    );
  }
}
