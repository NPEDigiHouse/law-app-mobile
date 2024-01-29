import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/glossary/presentation/pages/glossary_home_page.dart';
import 'package:law_app/features/shared/library/presentation/pages/library_home_page.dart';
import 'package:law_app/features/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:law_app/features/student/presentation/pages/student_course_page.dart';
import 'package:law_app/features/student/presentation/pages/student_discussion_page.dart';
import 'package:law_app/features/student/presentation/pages/student_home_page.dart';
import 'package:law_app/features/teacher/presentation/pages/teacher_discussion_page.dart';
import 'package:law_app/features/teacher/presentation/pages/teacher_home_page.dart';

class MainMenuPage extends StatefulWidget {
  final int roleId;

  const MainMenuPage({super.key, required this.roleId});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  late final ValueNotifier<int> selectedIndex;
  late final PageController pageController;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    selectedIndex = ValueNotifier(0);
    pageController = PageController();
    pages = widget.roleId == 2
        ? [
            const StudentHomePage(),
            const StudentDiscussionPage(),
            const StudentCoursePage(),
            const LibraryHomePage(),
            const GlossaryHomePage(),
          ]
        : [
            const TeacherHomePage(),
            const TeacherDiscussionPage(),
            const LibraryHomePage(),
            const GlossaryHomePage(),
          ];
  }

  @override
  void dispose() {
    super.dispose();

    selectedIndex.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: pages,
        onPageChanged: (index) => selectedIndex.value = index,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, index, child) {
          return CustomBottomNavigationBar(
            roleId: widget.roleId,
            currentIndex: index,
            onTap: (index) => pageController.jumpToPage(index),
          );
        },
      ),
    );
  }
}
