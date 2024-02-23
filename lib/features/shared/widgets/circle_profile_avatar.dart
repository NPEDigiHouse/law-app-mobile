import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class CircleProfileAvatar extends StatelessWidget {
  final String image;
  final double radius;
  final Color? borderColor;
  final double borderSize;

  const CircleProfileAvatar({
    super.key,
    required this.image,
    this.radius = 24.0,
    this.borderColor = secondaryColor,
    this.borderSize = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius - borderSize,
        foregroundImage: AssetImage(
          AssetPath.getImage(image),
        ),
      ),
    );
  }
}
