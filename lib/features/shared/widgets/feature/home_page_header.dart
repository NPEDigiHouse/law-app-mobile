// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/app_size.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/presentation/providers/user_credential_provider.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class HomePageHeader extends ConsumerWidget {
  final bool isProfile;
  final Widget child;

  const HomePageHeader({
    super.key,
    this.isProfile = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (isProfile)
          SizedBox(
            height: AppSize.getAppHeight(context),
          ),
        Container(
          height: CredentialSaver.user!.role != 'admin' ? 224 : 248,
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
        ),
        Positioned(
          top: -20,
          right: 20,
          child: SvgAsset(
            assetPath: AssetPath.getVector('app_logo_white.svg'),
            color: tertiaryColor.withOpacity(.5),
            width: 160,
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              top: CredentialSaver.user!.role != 'admin' ? 16 : 36,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildHeaderContent(ref),
                SizedBox(
                  height: CredentialSaver.user!.role != 'admin' ? 16 : 20,
                ),
                child,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeaderContent(WidgetRef ref) {
    final userCredential = ref.watch(userCredentialProvider);

    return userCredential.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (user) {
        if (user == null) return const SizedBox();

        if (user.role != 'admin') {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                      FunctionHelper.getUserNickname(user.name!),
                      style: textTheme.headlineMedium!.copyWith(
                        color: accentTextColor,
                      ),
                    ),
                    Text(
                      user.role!.toCapitalize(),
                      style: textTheme.bodyMedium!.copyWith(
                        color: accentTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (!isProfile) {
                    navigatorKey.currentState!.pushNamed(profileRoute);
                  }
                },
                child: CircleProfileAvatar(
                  imageUrl: user.profilePicture,
                  radius: 20,
                ),
              ),
            ],
          );
        }

        return Container(
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
                      FunctionHelper.getUserNickname(user.name!),
                      style: textTheme.titleSmall!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  if (!isProfile) {
                    navigatorKey.currentState!.pushNamed(profileRoute);
                  }
                },
                child: CircleProfileAvatar(
                  imageUrl: user.profilePicture,
                  radius: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
