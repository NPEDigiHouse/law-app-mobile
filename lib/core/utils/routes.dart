import 'package:flutter/material.dart';
import 'package:law_app/features/common/auth/login_page.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// Some routes name
const loginRoute = '/login';

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case loginRoute:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
    default:
      return null;
  }
}
