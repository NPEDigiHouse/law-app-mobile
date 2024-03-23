// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_down_timer_provider.g.dart';

@riverpod
class CountDownTimer extends _$CountDownTimer {
  @override
  Stream<int> build({required int initialValue}) async* {
    var value = initialValue;

    while (value >= 0) {
      await Future.delayed(const Duration(seconds: 1));

      yield value--;
    }
  }
}
