// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/is_sign_in_provider.dart';
import 'package:law_app/features/auth/presentation/providers/log_out_provider.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(isSignInProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(isSignInProvider);
              },
            );
          } else if ('$error' == kUnauthorized) {
            ref.read(logOutProvider.notifier).logOut();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) => navigatePage(data.$1, data.$2),
      );
    });

    ref.listen(logOutProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) => context.showBanner(
          message: '$error',
          type: BannerType.error,
        ),
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pushReplacementNamed(
              loginRoute,
              arguments: {
                'message': 'Sesi telah berakhir. Silahkan login ulang.',
                'bannerType': BannerType.error,
              },
            );
          }
        },
      );
    });

    return const LoadingIndicator(withScaffold: true);
  }

  void navigatePage(bool? isSignIn, UserCredentialModel? userCredential) {
    if (isSignIn == null) return;

    if (isSignIn) {
      if (userCredential != null) {
        navigatorKey.currentState!.pushReplacementNamed(
          userCredential.role == 'admin' ? adminHomeRoute : mainMenuRoute,
        );
      }
    } else {
      navigatorKey.currentState!.pushReplacementNamed(loginRoute);
    }
  }
}
