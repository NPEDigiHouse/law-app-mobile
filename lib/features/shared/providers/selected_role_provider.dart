// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

const roles = ['Semua', 'Student', 'Teacher', 'Admin'];

final selectedRoleProvider = StateProvider.autoDispose<String>(
  (ref) => roles.first,
);
