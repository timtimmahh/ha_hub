import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:ha_hub/exts/widget_exts.dart';
import 'package:intl/intl.dart';

class WeatherCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => Text('');/*ObxValue<Rx<AllWeather>>(
      (weather) => [
            <Widget>[
              'https://www.weatherbit.io/static/img/icons/${weather.value.current!.weather!.first.icon}.png'
                  .cachedImage()
                  .expanded(flex: 1),
              [
                [
                  '${weather.value.current!.temp.toPrecision(1)}\u00b0F'.asText(style: Get.textTheme.headline2!),
                  hSpace(4.0),
                  [
                    '${weather.value.daily!.first.temp.max.toPrecision(1)}\u00b0F'
                        .asText(style: Get.textTheme.headline6!),
                    hSpace(8.0),
                    '${weather.value.daily!.first.temp.min.toPrecision(1)}\u00b0F'
                        .asText(style: Get.textTheme.headline6!),
                  ].column()
                ].row(mainAxisAlignment: MainAxisAlignment.start).contain(padding: EdgeInsets.only(left: 4.0)),
                weather.value.current!.weather!.first.description.capitalize!
                    .asText(style: Get.textTheme.headline5)
                    .contain(padding: EdgeInsets.only(left: 4.0)),
              ]
                  .column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start)
                  .contain(padding: EdgeInsets.only(top: 16.0))
                  .expanded(flex: 2)
            ].row(crossAxisAlignment: CrossAxisAlignment.start),
            vSpace(4.0),
            HourlyWeatherView(
              weather: weather.value,
            )
          ].column(mainAxisSize: MainAxisSize.min).contain(padding: EdgeInsets.all(8.0)) *//*)*//*,
      controller.allWeather);*/
}

class HourlyWeatherView extends GetView<HomeController> {
  final dateFormat = DateFormat('h a');
  final AllWeather weather;

  HourlyWeatherView({Key? key, required this.weather});

  @override
  Widget build(BuildContext context) => weather.hourly!
      .where((element) => element.dt * 1000 > DateTime.now().millisecondsSinceEpoch)
      .map<Widget>((hourlyTime) => [
            '${hourlyTime.temp.toPrecision(1)}\u00b0F'.asText(style: Get.textTheme.headline6!),
            'https://www.weatherbit.io/static/img/icons/${hourlyTime.weather!.first.icon}.png'.cachedImage(),
            dateFormat
                .format(DateTime.fromMillisecondsSinceEpoch(hourlyTime.dt * 1000))
                .asText(style: Get.textTheme.headline6!),
          ].column())
      .toList()
      .row(mainAxisAlignment: MainAxisAlignment.spaceEvenly)
      .scrollable(scrollDirection: Axis.horizontal)
      .contain(padding: EdgeInsets.all(4.0));
}
