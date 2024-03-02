// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

const userRoles = {
  'semua': '',
  'student': 'student',
  'teacher': 'teacher',
  'admin': 'admin',
};

final userRoleProvider = StateProvider.autoDispose<String>(
  (ref) => userRoles['semua']!,
);
