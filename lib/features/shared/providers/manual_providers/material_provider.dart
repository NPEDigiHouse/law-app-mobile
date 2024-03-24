// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleProvider = StateProvider.autoDispose<String?>((ref) => null);
final durationProvider = StateProvider.autoDispose<int?>((ref) => null);
final materialProvider = StateProvider.autoDispose<String?>((ref) => null);
