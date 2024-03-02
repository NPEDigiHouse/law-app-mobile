// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

const discussionStatus = {
  'semua': '',
  'open': 'open',
  'discuss': 'onDiscussion',
  'solved': 'solved',
};

final discussionStatusProvider =
    StateProvider.autoDispose<String>((ref) => discussionStatus['semua']!);

final discussionTypeProvider =
    StateProvider.autoDispose<String>((ref) => 'general');

final discussionCategoryIdProvider =
    StateProvider.autoDispose<int?>((ref) => null);
