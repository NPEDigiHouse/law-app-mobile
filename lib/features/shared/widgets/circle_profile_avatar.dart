// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
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
    if (imageUrl != null) {
      if (imageUrl!.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: imageUrl!,
          imageBuilder: (context, imageProvider) {
            return buildProfileImage(imageProvider);
          },
          placeholder: (context, url) {
            return SizedBox(
              width: radius,
              height: radius,
              child: const CircularProgressIndicator(
                color: accentColor,
                strokeWidth: 3,
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Icon(
              Icons.error_outline_outlined,
              color: primaryColor,
              size: radius,
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
