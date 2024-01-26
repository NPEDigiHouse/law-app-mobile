import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class StudentCoursePage extends StatelessWidget {
  const StudentCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text('Student Course Page'),
      ),
    );
  }
}
