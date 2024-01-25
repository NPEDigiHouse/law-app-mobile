import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:law_app/features/shared/glossary/glossary_page.dart';
import 'package:law_app/features/shared/library/library_page.dart';
import 'package:law_app/features/student/presentation/pages/student_course_page.dart';
import 'package:law_app/features/student/presentation/pages/student_discussion_page.dart';
import 'package:law_app/features/student/presentation/pages/student_home_page.dart';
import 'package:law_app/features/teacher/presentation/pages/teacher_discussion_page.dart';
import 'package:law_app/features/teacher/presentation/pages/teacher_home_page.dart';

final selectedMenuProvider = StateProvider<int>((ref) => 0);

class MainMenuPage extends StatefulWidget {
  final int roleId;

  const MainMenuPage({super.key, required this.roleId});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  late final PageController pageController;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    pages = widget.roleId == 1
        ? [
            const StudentHomePage(),
            const StudentDiscussionPage(),
            const StudentCoursePage(),
            const LibraryPage(),
            const GlossaryPage(),
          ]
        : [
            const TeacherHomePage(),
            const TeacherDiscussionPage(),
            const LibraryPage(),
            const GlossaryPage(),
          ];
  }

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(selectedMenuProvider);

        return Scaffold(
          backgroundColor: backgroundColor,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: pages,
            onPageChanged: (index) {
              ref.read(selectedMenuProvider.notifier).state = index;
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            roleId: widget.roleId,
            currentIndex: currentIndex,
            onTap: (index) => pageController.jumpToPage(index),
          ),
        );
      },
    );
  }
}
