// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final queryProvider = StateProvider.autoDispose<String>((ref) => '');
