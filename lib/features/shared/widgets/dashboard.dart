// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';

class Dashboard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const Dashboard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146,
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
      child: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Center(
              child: SizedBox(
                width: 84,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientBackgroundIcon(
                      icon: items[index]["icon"],
                      size: 56,
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        '${items[index]["count"]}',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        items[index]["text"],
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall!.copyWith(
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
