import 'package:flutter/material.dart';
import 'package:law_app/core/settings/app_settings.dart';
import 'package:law_app/core/styles/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
