// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/icon_with_gradient_background.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.dashboardItem,
  });

  final List dashboardItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      height: 140,
      width: double.infinity,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(dashboardItem.length, (index) {
          return SizedBox(
            width: 80.0,
            child: Column(
              children: [
                IconWithGradientBackground(
                  size: 58.0,
                  icon: dashboardItem[index]["icon"],
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Flexible(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: textTheme.bodyMedium!.copyWith(
                        color: primaryTextColor,
                      ),
                      children: [
                        TextSpan(
                          text: "${dashboardItem[index]["count"]}\n",
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: dashboardItem[index]["text"],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
