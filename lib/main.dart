// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:law_app/app.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Init credential saver
  CredentialSaver.init();

  // Prevent landscape orientation
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Time ago localization
  timeago.setLocaleMessages('id', timeago.IdMessages());
  timeago.setDefaultLocale('id');

  runApp(
    const ProviderScope(
      child: LawApp(),
    ),
  );
}
