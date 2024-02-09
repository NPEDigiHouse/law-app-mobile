import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_home_page.dart';
import 'package:law_app/features/library/presentation/pages/library_home_page.dart';
import 'package:law_app/features/shared/widgets/custom_navigation_bar.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_page.dart';
import 'package:law_app/features/student/presentation/discussion/pages/student_discussion_home_page.dart';
import 'package:law_app/features/student/presentation/home/pages/student_home_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_discussion_home_page.dart';
import 'package:law_app/features/teacher/presentation/home/pages/teacher_home_page.dart';

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
    pages = widget.roleId == 1
        ? [
            const StudentHomePage(),
            const StudentDiscussionHomePage(),
            const StudentCoursePage(),
            const LibraryHomePage(),
            const GlossaryHomePage(),
          ]
        : [
            const TeacherHomePage(),
            const TeacherDiscussionHomePage(),
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
        onPageChanged: (index) => selectedIndex.value = index,
        children: pages,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, index, child) {
          return CustomNavigationBar(
            roleId: widget.roleId,
            currentIndex: index,
            onTap: (index) => pageController.jumpToPage(index),
          );
        },
      ),
    );
  }
}
