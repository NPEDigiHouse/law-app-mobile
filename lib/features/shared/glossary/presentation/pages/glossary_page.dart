import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/glossary/presentation/widgets/glossary_app_bar.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      appBar: GlossaryAppBar(),
      body: Center(
        child: Text('Glossary Page'),
      ),
    );
  }
}
