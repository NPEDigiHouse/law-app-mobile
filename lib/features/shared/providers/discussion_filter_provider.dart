// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discussionTypeProvider = StateProvider.autoDispose<String>(
  (ref) => 'general',
);

const discussionStatus = {
  'Semua': '',
  'Open': 'open',
  'Discuss': 'onDiscussion',
  'Solved': 'solved',
};

final discussionStatusProvider = StateProvider.autoDispose<String>(
  (ref) => discussionStatus['Semua']!,
);
