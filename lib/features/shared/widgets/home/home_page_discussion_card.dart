import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class HomePageDiscussionCard extends StatelessWidget {
  final Map<String, String> item;

  const HomePageDiscussionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(2, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            item["title"]!,
            maxLines: 3,
            style: textTheme.titleSmall!.copyWith(
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item["description"]!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall!.copyWith(
              color: primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
