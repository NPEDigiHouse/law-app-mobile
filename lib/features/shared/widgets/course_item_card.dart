import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CourseItemCard extends StatelessWidget {
  final Map courseItem;
  const CourseItemCard({
    Key? key,
    required this.courseItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.0,
      padding: const EdgeInsets.all(12.0),
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
        children: [
          Container(
            width: 105.0,
            height: 105.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage(
                  AssetPath.getImage(courseItem["img"]),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: GradientColors.redPastel,
                  ),
                  backgroundBlendMode: BlendMode.softLight),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      courseItem["title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium!.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgAsset(
                          color: secondaryTextColor,
                          assetPath: AssetPath.getIcon("clock-solid.svg"),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "${courseItem["completionTime"]} jam",
                          style: textTheme.bodyMedium!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: infoColor),
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
                const SizedBox(
                  height: 4.0,
                ),
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
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          courseItem["totalStudent"].toString(),
                          style: textTheme.bodyMedium!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomRatingStar(
                            rating: courseItem["rating"],
                            size: 18.0,
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
    Key? key,
    required this.rating,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int floorRating = rating.floor();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: size,
          clipBehavior: Clip.antiAlias,
          decoration: const ShapeDecoration(
            shape: StarBorder(
              points: 5.00,
            ),
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
