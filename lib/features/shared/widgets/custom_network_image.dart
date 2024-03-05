// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class CustomNetworkImage extends StatelessWidget {
  final double? aspectRatio;
  final double? radius;
  final List<BoxShadow>? boxShadow;
  final String imageUrl;
  final double placeHolderSize;

  const CustomNetworkImage({
    super.key,
    this.aspectRatio,
    this.radius,
    this.boxShadow,
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
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return aspectRatio != null
            ? AspectRatio(
                aspectRatio: aspectRatio!,
                child: buildImageContainer(
                  decorationImage: DecorationImage(image: imageProvider),
                ),
              )
            : buildImageContainer(
                decorationImage: DecorationImage(image: imageProvider),
              );
      },
      placeholder: (context, url) {
        return AspectRatio(
          aspectRatio: aspectRatio ?? 1,
          child: buildImageContainer(
            child: SizedBox(
              width: placeHolderSize,
              height: placeHolderSize,
              child: CircularProgressIndicator(
                color: accentColor,
                strokeWidth: placeHolderSize >= 20 ? 3 : 2,
              ),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return AspectRatio(
          aspectRatio: aspectRatio ?? 1,
          child: buildImageContainer(
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

  Container buildImageContainer({
    DecorationImage? decorationImage,
    Widget? child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(radius ?? 0),
        boxShadow: boxShadow,
        image: decorationImage,
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
