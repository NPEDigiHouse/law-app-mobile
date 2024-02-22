// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/student/presentation/course/widgets/item_container.dart';

class ItemNavigationBottomSheet extends StatelessWidget {
  final int length;
  final ValueChanged<int> onItemTapped;

  const ItemNavigationBottomSheet({
    super.key,
    required this.length,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Navigasi Soal',
                  style: textTheme.titleLarge,
                ),
              ),
              CustomIconButton(
                iconName: 'close-line.svg',
                color: primaryTextColor,
                size: 24,
                tooltip: 'Tutup',
                onPressed: () => navigatorKey.currentState!.pop(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<ItemContainer>.generate(
              length,
              (index) => ItemContainer(
                number: index + 1,
                onTap: () => onItemTapped(index),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
