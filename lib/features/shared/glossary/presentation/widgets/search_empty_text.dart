import 'package:flutter/material.dart';
import 'package:law_app/core/styles/text_style.dart';

class SearchEmptyText extends StatelessWidget {
  final String title;
  final String subtitle;

  const SearchEmptyText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
          ),
        ],
      ),
    );
  }
}
