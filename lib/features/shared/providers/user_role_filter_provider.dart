// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

const userRoles = {
  'Semua': '',
  'Student': 'student',
  'Teacher': 'teacher',
  'Admin': 'admin',
};

final userRoleProvider = StateProvider.autoDispose<String>(
  (ref) => userRoles['Semua']!,
);
