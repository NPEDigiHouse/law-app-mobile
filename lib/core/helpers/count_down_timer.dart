abstract class CountDownTimer {
  Stream<int> getTimerStream(int initialValue);
}

class CountDownTimerImpl implements CountDownTimer {
  @override
  Stream<int> getTimerStream(int initialValue) async* {
    var value = initialValue;

    while (value >= 0) {
      await Future.delayed(const Duration(seconds: 1));

      yield value--;
    }
  }
}
