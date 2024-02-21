import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/app.dart';
import 'package:law_app/core/utils/credential_saver.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent landscape orientation
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Init credential saver
  CredentialSaver.init();

  runApp(
    const ProviderScope(
      child: LawApp(),
    ),
  );
}
