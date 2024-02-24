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
import 'package:law_app/features/auth/data/models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/is_sign_in_provider.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      isSignInProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(isSignInProvider);
                },
              );
            } else {
              context.showBanner(message: '$error', type: BannerType.error);
            }
          },
          data: (data) => navigatePage(data.$1, data.$2),
        );
      },
    );

    return const LoadingIndicator(withScaffold: true);
  }

  void navigatePage(bool? isSignIn, UserCredentialModel? userCredential) {
    if (isSignIn == null) return;

    if (isSignIn) {
      if (userCredential != null) {
        navigatorKey.currentState!.pushReplacementNamed(
          // TODO: change `student` to `admin` again
          userCredential.role == 'student' ? adminHomeRoute : mainMenuRoute,
          arguments: userCredential,
        );
      }
    } else {
      navigatorKey.currentState!.pushReplacementNamed(loginRoute);
    }
  }
}
