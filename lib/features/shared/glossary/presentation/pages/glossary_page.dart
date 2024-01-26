import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class GlossaryPage extends StatefulWidget {

  const GlossaryPage({super.key});

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  late final ValueNotifier<String> query;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      // appBar: ,
      body: Center(
        child: Text('Glossary Page'),
      ),
    );
  }
}
