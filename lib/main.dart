import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:law_app/law_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent landscape orientation
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const LawApp());
}
