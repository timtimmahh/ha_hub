import 'dart:async';
import 'dart:convert';

import 'package:dartkt/dartkt.dart' hide Config;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:ha_hub/app/modules/home/providers/weather_provider.dart';
import 'package:hassio_api/hassio_api.dart' hide State;

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

class HomeController extends GetxController {
  late final _weatherProvider = Get.find<WeatherProvider>();
  late final _hassIO = Get.find<HassIO>();
  late Config _hassIOConfig;
  late final allWeatherFuture = Future<AllWeather?>.value().obs;
  late Rx<AllWeather> _allWeather;
  SunState? _sunriseState;
  SunState? _sunsetState;
  late final Timer _weatherTimer;

  @override
  void onInit() {
    super.onInit();
    asyncInit().then((value) {
      allWeatherFuture.value = Future.value(value);
      _weatherTimer = Timer.periodic(Duration(minutes: 10), (timer) async {
        _allWeather.value = await _weatherProvider.getWeatherData(
            _hassIOConfig.latitude, _hassIOConfig.longitude);
        print('Updated weather data');
        _themeToggleCallback();
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _hassIO.webSocket.close();
    _weatherTimer.cancel();
    _sunriseState?.cancel();
    _sunsetState?.cancel();
    super.onClose();
  }

  _makeSunriseTimer() {
    print('Making sunrise timer');
    var now = DateTime.now();
    var sunriseDate = _allWeather.value.daily!
        .map<DateTime?>(
            (e) => e.sunrise.isUtc ? e.sunrise.toLocal() : e.sunrise)
        .firstWhere((sunrise) => sunrise?.isAfter(now) ?? false,
            orElse: () => null);
    if (sunriseDate != null && sunriseDate.isAfter(now)) {
      print(
          'Found next sunrise=${sunriseDate.toIso8601String()}, current=${_sunriseState?.toIso8601String()}');
      if (_sunriseState != null &&
          sunriseDate.isAtSameMomentAs(_sunriseState!)) {
        print('No change in sunrise, not creating timer.');
        return;
      }
      var sunriseEndDuration = sunriseDate.difference(now);
      print('Sunrise occurs in ${sunriseEndDuration.format()}');
      if (_sunriseState != null && _sunriseState!.isActive) {
        print('Canceling active timer');
        _sunriseState!.cancel();
      }
      print('Creating new timer');
      var timer = Timer(sunriseEndDuration, () {
        print('Sunrise: changed theme mode to light.');
        Get.changeThemeMode(ThemeMode.light);
        _makeSunsetTimer();
      });
      if (_sunriseState == null) {
        _sunriseState = SunState(sunriseDate, timer);
      } else {
        _sunriseState!
          .._stateTime = sunriseDate
          .._stateTimer = timer;
      }
    }
  }

  _makeSunsetTimer() {
    print('Making sunset timer');
    var now = DateTime.now();
    var sunsetDate = _allWeather.value.daily!
        .map<DateTime?>((e) => e.sunset.isUtc ? e.sunset.toLocal() : e.sunset)
        .firstWhere((sunset) => sunset?.isAfter(now) ?? false,
            orElse: () => null);
    if (sunsetDate != null && sunsetDate.isAfter(now)) {
      print(
          'Found next sunset=${sunsetDate.toIso8601String()}, current=${_sunsetState?.toIso8601String()}');
      if (_sunsetState != null && sunsetDate.isAtSameMomentAs(_sunsetState!)) {
        print('No change in sunset, not creating timer.');
        return;
      }
      var sunsetEndDuration = sunsetDate.difference(now);
      print('Sunset occurs in ${sunsetEndDuration.format()}');
      if (_sunsetState != null && _sunsetState!.isActive) {
        print('Canceling active timer');
        _sunsetState!.cancel();
      }
      print('Creating new timer');
      var timer = Timer(sunsetEndDuration, () {
        print('Sunset: changed theme mode to dark.');
        Get.changeThemeMode(ThemeMode.dark);
        _makeSunsetTimer();
      });
      if (_sunsetState == null) {
        _sunsetState = SunState(sunsetDate, timer);
      } else {
        _sunsetState!
          .._stateTime = sunsetDate
          .._stateTimer = timer;
      }
    }
  }

  _themeToggleCallback() {
    _makeSunriseTimer();
    _makeSunsetTimer();
  }

  Future<AllWeather> asyncInit() async {
    Completer<AllWeather> completer = Completer<AllWeather>();
    _hassIO.webSocket.getConfig((data) async {
      if (data.success) {
        _hassIOConfig = data.result!;
        _allWeather = (await _weatherProvider.getWeatherData(
                _hassIOConfig.latitude, _hassIOConfig.longitude))
            .obs;
        var _now = DateTime.now();
        if (_allWeather.value.current!.sunset.isBefore(_now) ||
            _allWeather.value.current!.sunrise.isAfter(_now)) {
          Get.changeThemeMode(ThemeMode.dark);
        } else if (_allWeather.value.current!.sunrise.isBefore(_now)) {
          Get.changeThemeMode(ThemeMode.light);
        }
        completer.complete(_allWeather.value);
      }
    });
    // _hassIO.webSocket.subscribeTimeChanges((time) {
    //   currentTime.value = DateTime.parse(time);
    // });
    _hassIO.webSocket.getStates((states) {
      print('Got states');
      print(JsonEncoder.withIndent('  ').convert(states
              ?.where((element) =>
                  element.entityId == 'weather.home' ||
                  element.entityId == 'weather.home_hourly')
              .toList() ??
          List<State>.empty()));
    });
    _hassIO.webSocket.subscribeStateChanges('weather.home',
        (oldState, newState) {
      print('Weather Home');
    });
    _hassIO.webSocket.subscribeStateChanges('weather.home_hourly',
        (oldState, newState) {
      print('Weather Home Hourly');
    });
    return completer.future;
  }

  Config get hassIOConfig => _hassIOConfig;

  Rx<AllWeather> get allWeather => _allWeather;

  CurrentWeather get current => allWeather.value.current!;

  List<HourlyWeather> get hourly => allWeather.value.hourly!;

  List<DailyWeather> get daily => allWeather.value.daily!;

  Future<List<WeatherAlerts>> get alerts async => allWeather.value.alerts!;
}
