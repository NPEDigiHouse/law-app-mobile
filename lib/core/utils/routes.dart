import 'package:flutter/material.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/admin/presentation/pages/admin_home_page.dart';
import 'package:law_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:law_app/features/auth/presentation/pages/login_page.dart';
import 'package:law_app/features/auth/presentation/pages/otp_page.dart';
import 'package:law_app/features/auth/presentation/pages/register_page.dart';
import 'package:law_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:law_app/features/common/menu/main_menu_page.dart';
import 'package:law_app/features/shared/glossary/presentation/pages/glossary_detail_page.dart';
import 'package:law_app/features/shared/glossary/presentation/pages/glossary_search_page.dart';
import 'package:law_app/features/shared/notification/notification_page.dart';
import 'package:law_app/features/shared/profile/profile_page.dart';
import 'package:law_app/features/student/presentation/pages/student_home_page.dart';
import 'package:law_app/features/teacher/presentation/pages/teacher_home_page.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// Some routes name
const loginRoute = '/login';
const registerRoute = '/register';
const forgotPasswordRoute = '/forgot-password';
const otpRoute = '/otp';
const resetPasswordRoute = '/reset-password';
const mainMenuRoute = '/main-menu';
const profileRoute = '/profile';
const notificationRoute = '/notification';
const studentHomeRoute = '/student-home';
const teacherHomeRoute = '/teacher-home';
const adminHomeRoute = '/admin-home';
const glossarySearchRoute = '/glossary-search';
const glossaryDetailRoute = '/glossary-detail';

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case loginRoute:
      final bannerData = settings.arguments as Map<String, Object>?;

      return MaterialPageRoute(
        builder: (_) => LoginPage(bannerData: bannerData),
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
    case resetPasswordRoute:
      return MaterialPageRoute(
        builder: (_) => const ResetPasswordPage(),
      );
    case profileRoute:
      final roleId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => ProfilePage(roleId: roleId),
      );
    case notificationRoute:
      return MaterialPageRoute(
        builder: (_) => const NotificationPage(),
      );
    case studentHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentHomePage(),
      );
    case teacherHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const TeacherHomePage(),
      );
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case mainMenuRoute:
      final roleId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => MainMenuPage(roleId: roleId),
      );
    case glossarySearchRoute:
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) => const GlossarySearchPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    case glossaryDetailRoute:
      final glossary = settings.arguments as Glossary;

      return MaterialPageRoute(
        builder: (_) => GlossaryDetailPage(glossary: glossary),
      );
    default:
      return null;
  }
}
