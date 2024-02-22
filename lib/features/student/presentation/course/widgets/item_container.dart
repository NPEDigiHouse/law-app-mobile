// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class ItemContainer extends StatelessWidget {
  final int number;
  final VoidCallback? onTap;

  const ItemContainer({
    super.key,
    required this.number,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: 48,
      height: 48,
      radius: 12,
      color: secondaryColor,
      onTap: onTap,
      child: Center(
        child: Text(
          number.toString(),
          style: textTheme.titleMedium!.copyWith(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
