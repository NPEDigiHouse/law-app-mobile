import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/helpers/count_down_timer.dart';

final timerProvider = Provider<CountDownTimer>((ref) => CountDownTimerImpl());

final countDownProvider = StreamProvider.autoDispose.family<int, int>(
  (ref, value) => ref.watch(timerProvider).getTimerStream(value),
);
