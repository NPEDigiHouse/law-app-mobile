// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/material_model.dart';

final titleProvider = StateProvider.autoDispose<String?>((ref) => null);
final durationProvider = StateProvider.autoDispose<String?>((ref) => null);
final materialProvider = StateProvider.autoDispose<String?>((ref) => null);

final articlesProvider = StateProvider.autoDispose<List<MaterialModel>>(
  (ref) => [],
);
