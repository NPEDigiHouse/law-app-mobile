import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CourseItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const CourseItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  AssetPath.getImage(item["img"]! as String),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: GradientColors.redPastel,
                ),
                backgroundBlendMode: BlendMode.softLight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item["title"]! as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium!.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgAsset(
                          color: secondaryTextColor,
                          assetPath: AssetPath.getIcon("clock-solid.svg"),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${item["completionTime"] as double} jam",
                          style: textTheme.bodyMedium!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: infoColor,
                        ),
                      ),
                      child: Text(
                        "Aktif",
                        style: textTheme.bodySmall!.copyWith(
                          color: infoColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgAsset(
                          color: secondaryTextColor,
                          assetPath: AssetPath.getIcon("users-solid.svg"),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item["totalStudent"] as int}',
                          style: textTheme.bodyMedium!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomRatingStar(
                            rating: item["rating"]! as double,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomRatingStar extends StatelessWidget {
  final double rating;
  final double size;

  const CustomRatingStar({
    super.key,
    required this.rating,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final floorRating = rating.floor();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: size,
          clipBehavior: Clip.antiAlias,
          decoration: const ShapeDecoration(
            shape: StarBorder(),
          ),
          child: Row(
            children: [
              // Container(
              //   width: (index == floorRating)
              //       ? size
              //       : size * (rating - floorRating),
              //   color: primaryColor,
              // ),
              Container(
                width: (index == floorRating)
                    ? size * (rating - floorRating)
                    : size,
                color:
                    (index <= floorRating) ? accentColor : secondaryTextColor,
              ),
              Expanded(
                child: Container(
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
