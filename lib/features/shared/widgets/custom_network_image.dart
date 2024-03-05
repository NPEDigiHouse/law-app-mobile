// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class CustomNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final double? aspectRatio;
  final String imageUrl;
  final double placeHolderSize;

  const CustomNetworkImage({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.aspectRatio,
    required this.imageUrl,
    required this.placeHolderSize,
  });

  @override
  Widget build(BuildContext context) {
    var url = imageUrl;

    if (!imageUrl.contains(ApiConfigs.baseFileUrl)) {
      url = '${ApiConfigs.baseFileUrl}/$imageUrl';
    }

    return CachedNetworkImage(
      width: width,
      height: height,
      fit: BoxFit.fill,
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: aspectRatio != null
              ? AspectRatio(
                  aspectRatio: aspectRatio!,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider),
                  ),
                ),
        );
      },
      placeholder: (context, url) {
        return Center(
          child: SizedBox(
            width: placeHolderSize,
            height: placeHolderSize,
            child: CircularProgressIndicator(
              color: accentColor,
              strokeWidth: placeHolderSize >= 20 ? 3 : 2,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          color: secondaryColor,
          child: Center(
            child: Icon(
              Icons.no_photography_outlined,
              color: primaryColor,
              size: placeHolderSize - 8,
            ),
          ),
        );
      },
    );
  }
}
