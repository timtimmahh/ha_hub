import 'dart:math';

import 'package:dartkt/dartkt.dart';

abstract class AlarmTime {
  DateTime nextAlarmTime;

  AlarmTime(this.nextAlarmTime);

  factory AlarmTime.fromJson(Map<String, dynamic> json) =>
      json.containsKey('time') ? FixedAlarmTime.fromJson(json) : VariableAlarmTime.fromJson(json);

  DateTime _updateAlarmTime();

  void updateAlarmTime() {
    nextAlarmTime = _updateAlarmTime();
  }
}

class FixedAlarmTime extends AlarmTime {
  FixedAlarmTime(DateTime time) : super(time);

  factory FixedAlarmTime.fromJson(Map<String, dynamic> json) =>
      FixedAlarmTime(DateTime.fromMillisecondsSinceEpoch(json['time'], isUtc: true));

  Map<String, dynamic> toJson() => {'time': nextAlarmTime.toUtc().millisecondsSinceEpoch};

  @override
  DateTime _updateAlarmTime() => nextAlarmTime;
}

class VariableAlarmTime extends AlarmTime {
  int onDays;
  int onHour;
  int onMinute;

  VariableAlarmTime(this.onDays, this.onHour, this.onMinute) : super(_getAlarmTime(onDays, onHour, onMinute));

  factory VariableAlarmTime.fromJson(Map<String, dynamic> json) =>
      VariableAlarmTime(json['on_days'], json['on_hour'], json['on_minute']);

  Map<String, dynamic> toJson() => {'on_days': onDays, 'on_hour': onHour, 'on_minute': onMinute};

  static DateTime _getAlarmTime(int onDays, int onHour, int onMinute) {
    var _now = DateTime.now().toUtc();
    var _weekday = _now.weekday;
    int _dayOffset = 0;
    while (_weekday & onDays == 0 ||
        _weekday & onDays > 0 && (_now.hour > onHour || _now.hour == onHour && _now.minute > onMinute)) {
      _weekday = pow(2, (((log(_weekday) / log(2)) + 1) % 7).toInt()).toInt();
      _dayOffset++;
    }
    _now = _now.add(Duration(days: _dayOffset));
    return DateTime.utc(_now.year, _now.month, _now.day, onHour, onMinute);
  }

  @override
  DateTime _updateAlarmTime() => _getAlarmTime(onDays, onHour, onMinute);
}

class Alarm {
  bool activated;
  String name;
  AlarmTime alarmTime;
  String alarmSound;
  Snooze snoozeSettings;
  List<String> automations;

  Alarm(
      {required this.activated,
      required this.name,
      required this.alarmTime,
      required this.alarmSound,
      required this.snoozeSettings,
      required this.automations});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      activated: json['activated'],
      name: json['name'],
      alarmTime: AlarmTime.fromJson(json['alarm_time']),
      alarmSound: json['alarm_sound'],
      snoozeSettings: Snooze.fromJson(json['snooze_settings']),
      automations: json['automations']);

  Map<String, dynamic> toJson() => {
        'activated': activated,
        'name': name,
        'alarm_time': alarmTime,
        'alarm_sound': alarmSound,
        'snooze_settings': snoozeSettings,
        'automations': automations
      };

  DateTime get nextAlarmTime => alarmTime.nextAlarmTime;

  String get nextAlarmTimeString {
    var _now = DateTime.now().toUtc();
    var _nextAlarmTime = nextAlarmTime;
    if (_nextAlarmTime.day == _now.day || _nextAlarmTime.day == (_now.day + 1)) {
      return _nextAlarmTime.toLocal().format('H:mm a');
    }
    return _nextAlarmTime.toLocal().format('EEE, MMMM d h:mm a');
  }
}

class Snooze {
  Duration duration;
  int repeat;

  Snooze(this.duration, this.repeat);

  factory Snooze.fromJson(Map<String, dynamic> json) =>
      Snooze(Duration(milliseconds: json['duration']), json['repeat']);

  Map<String, dynamic> toJson() => {'duration': duration.inMilliseconds, 'repeat': repeat};
}
