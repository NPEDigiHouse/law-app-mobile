import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text('Glossary Page'),
      ),
    );
  }
}
