import 'dart:async';

/// A simple timer that fires events in regular increments and gets the current time.
///
/// CurrentTimeCounter implements [Stream] and sends itself as the event. From the
/// timer you can get the [time], or [cancel] the
/// timer.
class CurrentTimeStream extends Stream<CurrentTimeStream> {
  /// Creates a new [CurrentTimeStream] that fires events in increments of
  /// [increment].
  ///
  /// [stopwatch] is for testing purposes. If you're using CountdownTimer and
  /// need to control time in a test, pass a mock or a fake. See [FakeAsync]
  /// and [FakeStopwatch].
  CurrentTimeStream(this.increment, {Stopwatch? stopwatch})
      : _controller =
            StreamController<CurrentTimeStream>.broadcast(sync: true) {
    _timer = Timer.periodic(increment, _tick);
  }

  static const _THRESHOLD_MS = 4;

  /// The duration between timer events.
  final Duration increment;
  final StreamController<CurrentTimeStream> _controller;
  late final Timer _timer;

  @override
  StreamSubscription<CurrentTimeStream> listen(
          void Function(CurrentTimeStream event)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      _controller.stream.listen(onData, onError: onError, onDone: onDone);

  DateTime get time => DateTime.now();

  bool get isRunning => _timer.isActive;

  void cancel() {
    _timer.cancel();
    _controller.close();
  }

  void _tick(Timer timer) {
    _controller.add(this);
  }
}
