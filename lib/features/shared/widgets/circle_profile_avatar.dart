// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class CircleProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? borderColor;
  final double borderSize;

  const CircleProfileAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24.0,
    this.borderColor = secondaryColor,
    this.borderSize = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    var url = imageUrl;

    if (imageUrl != null) {
      if (!imageUrl!.contains(ApiConfigs.baseFileUrl)) {
        url = '${ApiConfigs.baseFileUrl}/$imageUrl';
      }
    }

    if (url != null) {
      if (url.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) {
            return buildProfileImage(imageProvider);
          },
          placeholder: (context, url) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: secondaryColor,
              child: SizedBox(
                width: radius - 4,
                height: radius - 4,
                child: const CircularProgressIndicator(
                  color: accentColor,
                  strokeWidth: 3,
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: secondaryColor,
              child: Icon(
                Icons.no_photography_outlined,
                color: primaryColor,
                size: radius - 4,
              ),
            );
          },
        );
      }
    }

    return buildProfileImage(
      AssetImage(AssetPath.getImage('no-profile-2.jpg')),
    );
  }

  CircleAvatar buildProfileImage(ImageProvider<Object> imageProvider) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius - borderSize,
        foregroundImage: imageProvider,
      ),
    );
  }
}
