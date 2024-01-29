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
      height: 140,
      padding: const EdgeInsets.all(12),
      width: double.infinity,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<SizedBox>.generate(
          items.length,
          (index) {
            return SizedBox(
              width: 80,
              child: Column(
                children: [
                  GradientBackgroundIcon(
                    icon: items[index]["icon"] as String,
                    size: 58,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.bodyMedium!.copyWith(
                          color: primaryTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: "${items[index]["count"] as int}\n",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: items[index]["text"] as String,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
