import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/app_size.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class HomePageHeader extends StatelessWidget {
  final User user;
  final bool isProfile;
  final VoidCallback? onPressedProfileIcon;
  final Widget? child;

  const HomePageHeader({
    super.key,
    required this.user,
    this.isProfile = false,
    this.onPressedProfileIcon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (isProfile)
          SizedBox(
            height: AppSize.getAppHeight(context),
          ),
        Container(
          height: !(user.roleId == 0) ? 224 : 248,
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
                top: !(user.roleId == 0) ? 20 : 40,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: !(user.roleId == 0)
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang,',
                                    style: textTheme.bodyLarge!.copyWith(
                                      color: scaffoldBackgroundColor,
                                    ),
                                  ),
                                  Text(
                                    FunctionHelper.getUserNickname(
                                      user.fullName,
                                    ),
                                    style: textTheme.headlineMedium!.copyWith(
                                      color: accentTextColor,
                                    ),
                                  ),
                                  Text(
                                    '${getRoleById(user.roleId)}',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: accentTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                CustomIconButton(
                                  iconName: 'notification-solid.svg',
                                  color: scaffoldBackgroundColor,
                                  size: 36,
                                  tooltip: 'Notifikasi',
                                  onPressed: () {
                                    navigatorKey.currentState!.pushNamed(
                                      notificationRoute,
                                    );
                                  },
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: onPressedProfileIcon,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: scaffoldBackgroundColor,
                                      border: Border.all(
                                        color: accentColor,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      foregroundImage: AssetImage(
                                        AssetPath.getImage("no-profile.jpg"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SvgAsset(
                                width: 40,
                                height: 40,
                                assetPath: AssetPath.getVector("app_logo.svg"),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sobat Hukum App',
                                      style: textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Admin',
                                      style: textTheme.titleSmall!.copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: onPressedProfileIcon,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: scaffoldBackgroundColor,
                                    border: Border.all(
                                      color: accentColor,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    foregroundImage: AssetImage(
                                      AssetPath.getImage("no-profile.jpg"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: !(user.roleId == 0) ? 140 : 170,
          left: 20,
          right: 20,
          child: child!,
        ),
      ],
    );
  }

  String? getRoleById(int id) {
    switch (id) {
      case 0:
        return 'Admin';
      case 1:
        return 'Student';
      case 2:
        return 'Pakar';
      default:
        return null;
    }
  }
}
