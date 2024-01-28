// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? rightIcon;
  final String title;

  const CustomAppBar({
    Key? key,
    this.rightIcon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: textTheme.headlineSmall!.copyWith(
          color: scaffoldBackgroundColor,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: GradientColors.redPastel,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -20,
              right: 20,
              child: SvgAsset(
                assetPath: AssetPath.getVector('app_logo_white.svg'),
                color: tertiaryColor,
                width: 160,
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            navigatorKey.currentState!.pop();
                          },
                          icon: SvgAsset(
                            height: 24.0,
                            width: 24.0,
                            color: primaryColor,
                            assetPath: AssetPath.getIcon("caret-line-left.svg"),
                          ),
                        ),
                      ),
                      (rightIcon != null)
                          ? Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgAsset(
                                  height: 24.0,
                                  width: 24.0,
                                  color: primaryColor,
                                  assetPath: AssetPath.getIcon(rightIcon!),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}
