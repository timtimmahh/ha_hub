import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ha_hub/exts/current_time_stream.dart';

class CurrentTimeCounter extends StatefulWidget {
  final Widget Function(DateTime time) builder;
  final CurrentTimeStream _currentTimeStream;
  late final _currentTime = _currentTimeStream.time.obs;

  CurrentTimeCounter(
      {Key? key,
      required this.builder,
      Duration increment = const Duration(seconds: 1)})
      : _currentTimeStream = CurrentTimeStream(increment),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CurrentTimeCounterState();
}

class _CurrentTimeCounterState extends State<CurrentTimeCounter> {
  late StreamSubscription<CurrentTimeStream> _sub;

  @override
  Widget build(BuildContext context) => ObxValue<Rx<DateTime>>(
      (data) => widget.builder(data.value), widget._currentTime);

  @override
  void initState() {
    super.initState();
    _sub = widget._currentTimeStream.listen((data) {
      widget._currentTime.value = widget._currentTimeStream.time;
    }, onDone: () {
      _sub.cancel();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
