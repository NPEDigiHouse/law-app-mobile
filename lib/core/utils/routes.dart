import 'package:flutter/material.dart';
import 'package:law_app/features/common/auth/pages/change_password_page.dart';
import 'package:law_app/features/common/auth/pages/forgot_password_page.dart';
import 'package:law_app/features/common/auth/pages/login_page.dart';
import 'package:law_app/features/common/auth/pages/otp_page.dart';
import 'package:law_app/features/common/auth/pages/register_page.dart';
import 'package:law_app/features/student/presentation/pages/student_home_page.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// Some routes name
const loginRoute = '/login';
const registerRoute = '/register';
const forgotPasswordRoute = '/forgot-password';
const otpRoute = '/otp';
const changePasswordRoute = '/change-password';
const studentHomeRoute = '/student-home';

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case loginRoute:
      return MaterialPageRoute(
        builder: (_) => LoginPage(),
      );
    case registerRoute:
      return MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      );
    case forgotPasswordRoute:
      return MaterialPageRoute(
        builder: (_) => const ForgotpasswordPage(),
      );
    case otpRoute:
      final email = settings.arguments as String;

      return MaterialPageRoute(
        builder: (_) => OtpPage(email: email),
      );
    case changePasswordRoute:
      return MaterialPageRoute(
        builder: (_) => const ChangePasswordPage(),
      );
    case studentHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentHomePage(),
      );
    default:
      return null;
  }
}
