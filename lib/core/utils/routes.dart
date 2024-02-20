import 'package:flutter/material.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/admin/presentation/pages/admin_home_page.dart';
import 'package:law_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:law_app/features/auth/presentation/pages/login_page.dart';
import 'package:law_app/features/auth/presentation/pages/otp_page.dart';
import 'package:law_app/features/auth/presentation/pages/register_page.dart';
import 'package:law_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:law_app/features/common/ad/ad_detail_page.dart';
import 'package:law_app/features/common/menu/main_menu_page.dart';
import 'package:law_app/features/common/notification/notification_page.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_detail_page.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_search_page.dart';
import 'package:law_app/features/library/presentation/pages/library_book_detail_page.dart';
import 'package:law_app/features/library/presentation/pages/library_book_list_page.dart';
import 'package:law_app/features/library/presentation/pages/library_finished_book_page.dart';
import 'package:law_app/features/library/presentation/pages/library_saved_book_page.dart';
import 'package:law_app/features/library/presentation/pages/library_search_page.dart';
import 'package:law_app/features/profile/presentation/pages/account_info_page.dart';
import 'package:law_app/features/profile/presentation/pages/certificate_page.dart';
import 'package:law_app/features/profile/presentation/pages/contact_us_page.dart';
import 'package:law_app/features/profile/presentation/pages/faq_page.dart';
import 'package:law_app/features/profile/presentation/pages/profile_page.dart';
import 'package:law_app/features/shared/pages/public_discussion_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_article_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_detail_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_lesson_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_progress_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_quiz_home_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_quiz_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_rate_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_search_page.dart';
import 'package:law_app/features/student/presentation/discussion/pages/student_discussion_detail_page.dart';
import 'package:law_app/features/student/presentation/discussion/pages/student_question_list_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_discussion_detail_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_question_history_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_question_list_page.dart';

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
const accountInfoRoute = '/profile/account-info';
const faqRoute = '/profile/faq';
const contactUsRoute = '/profile/contact-us';
const certificateRoute = '/profile/certificate';
const notificationRoute = '/notification';
const adDetailRoute = '/ad-detail';

const glossarySearchRoute = '/glossary-search';
const glossaryDetailRoute = '/glossary-detail';

const libraryBookListRoute = '/library-book-list';
const libraryFinishedBookRoute = '/library-finished-book';
const librarySavedBookRoute = '/library-saved-book';
const librarySearchRoute = '/library-search';
const libraryBookDetailRoute = '/library-book-detail';

const publicDiscussionRoute = '/public-discussion';
const studentQuestionListRoute = '/student-question-list';
const studentDiscussionDetailRoute = '/student-discussion-detail';
const teacherQuestionListRoute = '/teacher-question-list';
const teacherDiscussionDetailRoute = '/teacher-discussion-detail';
const teacherQuestionHistoryRoute = '/teacher-question-history';

const studentCourseSearchRoute = '/student-course-search';
const studentCourseDetailRoute = '/student-course-detail';
const studentCourseProgressRoute = '/student-course-progress';
const studentCourseLessonRoute = '/student-course-lesson';
const studentCourseArticleRoute = '/student-course-article';
const studentCourseQuizHomeRoute = '/student-course-quiz-home';
const studentCourseQuizRoute = '/student-course-quiz';
const studentCourseRateRoute = '/student-course-rate';

const adminHomeRoute = '/admin-home';

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
    case mainMenuRoute:
      final roleId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => MainMenuPage(roleId: roleId),
      );
    case profileRoute:
      final user = settings.arguments as User;

      return MaterialPageRoute(
        builder: (_) => ProfilePage(user: user),
      );
    case accountInfoRoute:
      final user = settings.arguments as User;

      return MaterialPageRoute(
        builder: (_) => AccountInfoPage(user: user),
      );
    case faqRoute:
      return MaterialPageRoute(
        builder: (_) => const FAQPage(),
      );
    case contactUsRoute:
      return MaterialPageRoute(
        builder: (_) => const ContactUsPage(),
      );
    case certificateRoute:
      return MaterialPageRoute(
        builder: (_) => const CertificatePage(),
      );
    case notificationRoute:
      return MaterialPageRoute(
        builder: (_) => const NotificationPage(),
      );
    case adDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const AdDetailPage(),
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
    case libraryBookListRoute:
      return MaterialPageRoute(
        builder: (_) => const LibraryBookListPage(),
      );
    case libraryFinishedBookRoute:
      return MaterialPageRoute(
        builder: (_) => const LibraryFinishedBookPage(),
      );
    case librarySavedBookRoute:
      return MaterialPageRoute(
        builder: (_) => const LibrarySavedBookPage(),
      );
    case librarySearchRoute:
      return MaterialPageRoute(
        builder: (_) => const LibrarySearchPage(),
      );
    case libraryBookDetailRoute:
      final book = settings.arguments as Book;

      return MaterialPageRoute(
        builder: (_) => LibraryBookDetailRoute(book: book),
      );
    case publicDiscussionRoute:
      final roleId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => PublicDiscussionPage(roleId: roleId),
      );
    case studentQuestionListRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentQuestionListPage(),
      );
    case studentDiscussionDetailRoute:
      final question = settings.arguments as Question;

      return MaterialPageRoute(
        builder: (_) => StudentDiscussionDetailPage(question: question),
      );
    case teacherQuestionListRoute:
      return MaterialPageRoute(
        builder: (_) => const TeacherQuestionListPage(),
      );
    case teacherDiscussionDetailRoute:
      final question = settings.arguments as Question;

      return MaterialPageRoute(
        builder: (_) => TeacherDiscussionDetailPage(question: question),
      );
    case teacherQuestionHistoryRoute:
      return MaterialPageRoute(
        builder: (_) => const TeacherQuestionHistoryPage(),
      );
    case studentCourseSearchRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentCourseSearchPage(),
      );
    case studentCourseDetailRoute:
      final course = settings.arguments as Course;

      return MaterialPageRoute(
        builder: (_) => StudentCourseDetailPage(course: course),
      );
    case studentCourseProgressRoute:
      final courseDetail = settings.arguments as CourseDetail;

      return MaterialPageRoute(
        builder: (_) => StudentCourseProgressPage(courseDetail: courseDetail),
      );
    case studentCourseLessonRoute:
      final curriculum = settings.arguments as Curriculum;

      return MaterialPageRoute(
        builder: (_) => StudentCourseLessonPage(curriculum: curriculum),
      );
    case studentCourseArticleRoute:
      final article = settings.arguments as Article;

      return MaterialPageRoute(
        builder: (_) => StudentCourseArticlePage(article: article),
      );
    case studentCourseQuizHomeRoute:
      final quiz = settings.arguments as Quiz;

      return MaterialPageRoute(
        builder: (_) => StudentCourseQuizHomePage(quiz: quiz),
      );
    case studentCourseQuizRoute:
      final args = settings.arguments as StudentCourseQuizArgs;

      return MaterialPageRoute(
        builder: (_) => StudentCourseQuizPage(
          duration: args.duration,
          items: args.items,
        ),
      );
    case studentCourseRateRoute:
      final courseDetail = settings.arguments as CourseDetail;

      return MaterialPageRoute(
        builder: (_) => StudentCourseRatePage(courseDetail: courseDetail),
      );
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    default:
      return null;
  }
}
