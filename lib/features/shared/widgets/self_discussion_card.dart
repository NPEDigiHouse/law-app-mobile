import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class SelfDiscussionCard extends StatelessWidget {
  final Map<String, String> item;

  const SelfDiscussionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(2, 2),
          blurRadius: 4,
          spreadRadius: -1,
        )
      ],
      child: Column(
        children: [
          if (item['category'] != null && item['status'] != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['category']!,
                    style: textTheme.labelSmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                LabelChip(
                  text: item['status']!,
                  color: FunctionHelper.getColorByDiscussionStatus(
                    item['status']!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            item['title']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium!.copyWith(
              color: primaryColor,
              height: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item['description']!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall!.copyWith(
              color: primaryTextColor,
            ),
          ),
          if (item['created_at'] != null) ...[
            const SizedBox(height: 8),
            Text(
              item['created_at']!,
              textAlign: TextAlign.right,
              style: textTheme.labelSmall!.copyWith(
                color: secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
