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

  const CircleProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    var url = imageUrl;

    if (url != null) {
      if (url.isNotEmpty) {
        if (!imageUrl!.contains(ApiConfigs.baseFileUrl)) {
          url = '${ApiConfigs.baseFileUrl}/$imageUrl';
        }

        return CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: radius,
              foregroundImage: imageProvider,
            );
          },
          placeholder: (context, url) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: secondaryColor,
              child: SizedBox(
                width: radius - 4,
                height: radius - 4,
                child: CircularProgressIndicator(
                  color: accentColor,
                  strokeWidth: radius >= 20 ? 3 : 2,
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

    return CircleAvatar(
      radius: radius,
      foregroundImage: AssetImage(
        AssetPath.getImage('no-profile-2.jpg'),
      ),
    );
  }
}
