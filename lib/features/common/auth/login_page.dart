import 'package:flutter/material.dart';
import 'package:law_app/core/settings/app_settings.dart';
import 'package:law_app/core/styles/text_style.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppSettings.title,
          style: textTheme.headlineSmall,
        ),
      ),
    );
  }
}
