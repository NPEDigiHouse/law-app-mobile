import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';

class Dashboard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const Dashboard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<SizedBox>.generate(
          items.length,
          (index) => SizedBox(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GradientBackgroundIcon(
                  icon: items[index]["icon"] as String,
                  size: 58,
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    '${items[index]["count"] as int}',
                    style: textTheme.titleMedium!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    items[index]["text"] as String,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.copyWith(
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
