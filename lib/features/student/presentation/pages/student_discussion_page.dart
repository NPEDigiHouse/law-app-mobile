import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class StudentDiscussionPage extends StatelessWidget {
  const StudentDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text('Student Discussion Page'),
      ),
    );
  }
}
