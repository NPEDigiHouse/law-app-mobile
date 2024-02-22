// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
