import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class StudentDiscussionHomePage extends StatelessWidget {
  const StudentDiscussionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  HeaderContainer(
                    height: 250,
                    child: Column(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
