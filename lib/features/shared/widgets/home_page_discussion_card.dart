import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';

class HomePageDiscussioinCard extends StatelessWidget {
  final Map discussionItem;

  const HomePageDiscussioinCard({
    super.key,
    required this.discussionItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(2.0, 2.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            discussionItem["title"],
            maxLines: 3,
            style: textTheme.titleSmall!.copyWith(
              color: primaryColor,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            discussionItem["description"],
            style: textTheme.bodySmall!.copyWith(color: primaryTextColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}