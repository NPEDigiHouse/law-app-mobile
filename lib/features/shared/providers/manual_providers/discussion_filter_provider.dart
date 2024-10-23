// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

const discussionStatus = {
  'Semua': '',
  'Open': 'open',
  'Discuss': 'onDiscussion',
  'Solved': 'solved',
};

final discussionStatusProvider = StateProvider.autoDispose<String>((ref) => discussionStatus['Semua']!);

final discussionTypeProvider = StateProvider.autoDispose<String>((ref) => 'general');
