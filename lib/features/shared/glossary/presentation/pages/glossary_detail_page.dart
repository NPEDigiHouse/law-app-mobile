import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class GlossaryDetailPage extends StatelessWidget {
  final Glossary glossary;

  const GlossaryDetailPage({super.key, required this.glossary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Kata',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              glossary.term,
              style: textTheme.headlineSmall!.copyWith(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              glossary.definiton,
            ),
          ],
        ),
      ),
    );
  }
}
