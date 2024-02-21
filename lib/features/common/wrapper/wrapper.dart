import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/auth/presentation/providers/is_sign_in_provider.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      isSignInProvider,
      (_, state) {
        return state.whenOrNull(
          skipError: true,
          data: navigatePage,
        );
      },
    );

    return const LoadingIndicator(withScaffold: true);
  }

  void navigatePage(bool? isAlreadySignIn) {
    if (isAlreadySignIn != null) {
      if (isAlreadySignIn) {
        navigatorKey.currentState!.pushReplacementNamed(
          mainMenuRoute,
          arguments: user.roleId,
        );
      } else {
        navigatorKey.currentState!.pushReplacementNamed(
          loginRoute,
        );
      }
    }
  }
}
