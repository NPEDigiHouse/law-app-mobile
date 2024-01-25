import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text('Library Page'),
      ),
    );
  }
}
