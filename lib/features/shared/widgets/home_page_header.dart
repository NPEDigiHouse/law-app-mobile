// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class HomePageHeader extends StatelessWidget {
  final Widget child;

  const HomePageHeader({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
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
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: textTheme.headlineMedium,
                            children: [
                              const TextSpan(
                                text: 'Selamat Datang,\n',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              TextSpan(
                                text: '${user.username}!',
                                style: const TextStyle(
                                  color: accentTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          user.roleId == 0
                              ? "Admin"
                              : user.roleId == 1
                                  ? "Pakar"
                                  : "Siswa",
                          style: textTheme.bodyMedium!.copyWith(
                            color: accentTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: TextButton(
                          onPressed: () {
                            navigatorKey.currentState!
                                .pushNamed(notificationRoute);
                          },
                          child: SvgAsset(
                            width: 36,
                            height: 36,
                            color: scaffoldBackgroundColor,
                            assetPath: AssetPath.getIcon(
                              "notification-solid.svg",
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navigatorKey.currentState!.pushNamed(profileRoute);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scaffoldBackgroundColor,
                            border: Border.all(
                              color: accentColor,
                              width: 1.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 23,
                            foregroundImage: AssetImage(
                              AssetPath.getImage("no-profile.jpg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: child,
          ),
        ],
      ),
    );
  }
}
