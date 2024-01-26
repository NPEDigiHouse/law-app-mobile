import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dashboardItem.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dashboardItem.length > 3 ? 1.0 : 12.0,
            ),
            child: SizedBox(
              width: 80.0,
              child: Column(
                children: [
                  Container(
                    height: 58.0,
                    width: 58.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      gradient: LinearGradient(
                        colors: GradientColors.redPastel,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SvgAsset(
                      color: scaffoldBackgroundColor,
                      assetPath:
                          AssetPath.getIcon(dashboardItem[index]["icon"]),
                    ),
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
            ),
          );
        }),
      ),
    );
  }
}
