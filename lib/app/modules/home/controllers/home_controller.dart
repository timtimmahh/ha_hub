import 'dart:async';
import 'dart:convert';

import 'package:dartkt/dartkt.dart' hide Config;
import 'package:flutter/material.dart' hide State;
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/data/alarm_models.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:ha_hub/app/modules/home/providers/weather_provider.dart';
import 'package:hassio_api/hassio_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

class SunState implements Timer, DateTime {
  DateTime _stateTime;
  Timer _stateTimer;

  SunState(this._stateTime, this._stateTimer);

  @override
  void cancel() {
    _stateTimer.cancel();
  }

  @override
  bool get isActive => _stateTimer.isActive;

  @override
  int get tick => _stateTimer.tick;

  @override
  DateTime add(Duration duration) => _stateTime.add(duration);

  @override
  int compareTo(DateTime other) => _stateTime.compareTo(other);

  @override
  int get day => _stateTime.day;

  @override
  Duration difference(DateTime other) => _stateTime.difference(other);

  @override
  int get hour => _stateTime.hour;

  @override
  bool isAfter(DateTime other) => _stateTime.isAfter(other);

  @override
  bool isAtSameMomentAs(DateTime other) => _stateTime.isAtSameMomentAs(other);

  @override
  bool isBefore(DateTime other) => _stateTime.isBefore(other);

  @override
  bool get isUtc => _stateTime.isUtc;

  @override
  int get microsecond => _stateTime.microsecond;

  @override
  int get microsecondsSinceEpoch => _stateTime.microsecondsSinceEpoch;

  @override
  int get millisecond => _stateTime.millisecond;

  @override
  int get millisecondsSinceEpoch => _stateTime.millisecondsSinceEpoch;

  @override
  int get minute => _stateTime.minute;

  @override
  int get month => _stateTime.month;

  @override
  int get second => _stateTime.second;

  @override
  DateTime subtract(Duration duration) => _stateTime.subtract(duration);

  @override
  String get timeZoneName => _stateTime.timeZoneName;

  @override
  Duration get timeZoneOffset => _stateTime.timeZoneOffset;

  @override
  String toIso8601String() => _stateTime.toIso8601String();

  @override
  DateTime toLocal() => _stateTime.toLocal();

  @override
  DateTime toUtc() => _stateTime.toUtc();

  @override
  int get weekday => _stateTime.weekday;

  @override
  int get year => _stateTime.year;
}

class WeatherForecast {
  WeatherState _dailyWeather;
  WeatherState _hourlyWeather;

  WeatherForecast(this._dailyWeather, this._hourlyWeather);

  /*void updateState({WeatherState? dailyWeather, WeatherState? hourlyWeather}) {
    if (dailyWeather != null && _dailyWeather != dailyWeather) {
      _dailyWeather = dailyWeather;
    }
    if (hourlyWeather != null && _hourlyWeather != hourlyWeather) {
      _hourlyWeather = hourlyWeather;
    }
  }*/

  WeatherState get daily => _dailyWeather;
  WeatherState get hourly => _hourlyWeather;

}

class HomeController extends GetxController {
  // late final _weatherProvider = Get.find<WeatherProvider>();
  late final _hassIO = Get.find<HassIO>();
  late Config _hassIOConfig;

  late final weatherForecastFuture = Future<WeatherForecast?>.value().obs;

  // late Rx<AllWeather> _allWeather;
  late SunEntityState sunState;
  late Rxn<WeatherForecast> weatherForecast = Rxn();
  SunState? _sunCycleTimer;

  // SunState? _sunsetState;
  // late final Timer _weatherTimer;
  late SharedPreferences preferences;
  late final alarms = List<Alarm>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    /*shelf_io.serve(webSocketHandler((webSocket) {
      webSocket.stream.listen((message) {
        print('WebSocket message: $message');
      });
    }), 'localhost', 8123).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });*/
    asyncInit(); //.then((value) {
    // allWeatherFuture.value = Future.value(value);
    // _weatherTimer = Timer.periodic(Duration(minutes: 10), (timer) async {
    // _allWeather.value = await _weatherProvider.getWeatherData(_hassIOConfig.latitude, _hassIOConfig.longitude);
    // print('Updated weather data');
    // _themeToggleCallback();
    // });
    //});
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _hassIO.webSocket.close();
    // _weatherTimer.cancel();
    _sunCycleTimer?.cancel();
    // _sunsetState?.cancel();
    super.onClose();
  }

  List<Alarm> get _alarms {
    return (jsonDecode(preferences.getString('alarms') ?? '[]') as List)
        .mapL((it) => Alarm.fromJson(it))
        .sortByDescending((first, second) =>
            first.nextAlarmTime.compareTo(second.nextAlarmTime));
  }

  Pair<DateTime, ThemeMode>? _getNextSunCycle() {
    if (sunState.nextRising == null && sunState.nextSetting != null) {
      return sunState.nextSetting!.to(ThemeMode.dark);
    } else if (sunState.nextSetting == null && sunState.nextRising != null) {
      return sunState.nextRising!.to(ThemeMode.light);
    } else if (sunState.nextSetting != null && sunState.nextRising != null) {
      if (sunState.nextRising!.isBefore(sunState.nextSetting!)) {
        return sunState.nextRising!.to(ThemeMode.light);
      } else {
        return sunState.nextSetting!.to(ThemeMode.dark);
      }
    }
    return null;
  }

  _makeSunCycleTimer({bool setInitial = false}) {
    print('Making sun cycle timer');
    var _sunCycle = _getNextSunCycle();
    if (_sunCycle == null) {
      return;
    } else if (setInitial) {
      Get.changeThemeMode(_sunCycle.right == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light);
    }
    DateTime? nextCycle = _sunCycle.left;
    ThemeMode? mode = _sunCycle.right;
    var now = DateTime.now();
    var timerDuration = nextCycle.difference(now);
    print('Sun cycle occurs in ${timerDuration.format()}');
    if (_sunCycleTimer != null) {
      if (_sunCycleTimer!.isActive) {
        print('Canceling active timer');
        _sunCycleTimer!.cancel();
      }
      if (nextCycle.isAtSameMomentAs(_sunCycleTimer!._stateTime)) {
        return;
      }
    }
    print('Creating new timer');
    var timer = Timer(timerDuration, () {
      print('Sun Cycle: changed theme mode to $mode.');
      Get.changeThemeMode(mode);
      _makeSunCycleTimer();
    });
    if (_sunCycleTimer == null) {
      _sunCycleTimer = SunState(nextCycle, timer);
    } else {
      _sunCycleTimer!
        .._stateTime = nextCycle
        .._stateTimer = timer;
    }
  }

  _themeToggleCallback() {
    _makeSunCycleTimer();
  }

  void updateSunState(SunEntityState newState, {bool setInitial = false}) {
    sunState = newState;
    _makeSunCycleTimer();
  }

  void updateWeatherState(
      {WeatherState? dailyWeather, WeatherState? hourlyWeather}) {
    if (dailyWeather != null) {
      print(JsonEncoder.withIndent('  ').convert(dailyWeather));
    }
    if (hourlyWeather != null) {
      print(JsonEncoder.withIndent('  ').convert(hourlyWeather));
    }
    if (weatherForecast.value != null) {
      weatherForecast.update((val) {
        if (dailyWeather != null) {
          val!._dailyWeather = dailyWeather;
        }
        if (hourlyWeather != null) {
          val!._hourlyWeather = hourlyWeather;
        }
      });
    } else if (dailyWeather != null && hourlyWeather != null) {
      weatherForecast.value = WeatherForecast(dailyWeather, hourlyWeather);
      weatherForecastFuture.value = Future.value(weatherForecast.value);
    }
  }

  /*Future<WeatherForecast>*/
  void asyncInit() async {
    preferences = await SharedPreferences.getInstance();
    alarms.value = _alarms;
    _hassIO.webSocket.getConfig((data) async {
      if (data.success) {
        _hassIOConfig = data.result!;
      }
    });

    _hassIO.webSocket.getStates((states) {
      print('Got states');
      if (states != null) {
        updateSunState(
            states.firstWhere((element) => element.entityId == 'sun.sun').let(
                (it) => SunEntityState(
                    it.attributes, it.entityId, it.lastChanged, it.state)),
            setInitial: true);
        // _makeSunCycleTimer(set_initial: true);
        // var dailyWeatherState = ;
        // var hourlyWeatherState = ;
        updateWeatherState(
            dailyWeather: states
                .firstWhere((element) => element.entityId == 'weather.home')
                .let((it) => WeatherState(
                    it.attributes, it.entityId, it.lastChanged, it.state)),
            hourlyWeather: states
                .firstWhere(
                    (element) => element.entityId == 'weather.home_hourly')
                .let((it) => WeatherState(
                    it.attributes, it.entityId, it.lastChanged, it.state)));
        /*weatherForecast =
            WeatherForecast(dailyWeatherState, hourlyWeatherState).obs;
        weatherForecastFuture.value = Future.value(weatherForecast.value);*/
      }
      /*print(JsonEncoder.withIndent('  ').convert(states
              ?.where((element) => element.entityId == 'weather.home' || element.entityId == 'weather.home_hourly' || element.entityId == 'sun.sun')
              .toList() ??
          List<State>.empty()));*/
    });
    _hassIO.webSocket.subscribeStateChanges('sun.sun', (oldState, newState) {
      print(JsonEncoder.withIndent('  ').convert(newState));
      updateSunState(SunEntityState.fromJson(newState));
    });
    _hassIO.webSocket.subscribeStateChanges('weather.home',
        (oldState, newState) {
      print('Weather Home');
      // print(JsonEncoder.withIndent(' ').convert(newState));
      // State _oldState = State.fromJson(oldState);
      // WeatherState _newState = ;
      updateWeatherState(dailyWeather: WeatherState.fromJson(newState));
    });
    _hassIO.webSocket.subscribeStateChanges('weather.home_hourly',
        (oldState, newState) {
      print('Weather Home Hourly');
      // WeatherState _newState = ;
      updateWeatherState(hourlyWeather: WeatherState.fromJson(newState));
    });
    // return completer.future;
  }

  Config get hassIOConfig => _hassIOConfig;

// Rx<AllWeather> get allWeather => _allWeather;

// CurrentWeather get current => allWeather.value.current!;

// List<HourlyWeather> get hourly => allWeather.value.hourly!;

// List<DailyWeather> get daily => allWeather.value.daily!;

// Future<List<WeatherAlerts>> get alerts async => allWeather.value.alerts!;
}
