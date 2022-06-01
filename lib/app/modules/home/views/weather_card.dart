import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/app/modules/home/data/icon_data.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:ha_hub/exts/widget_exts.dart';
import 'package:intl/intl.dart';

class WeatherCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => ObxValue<Rxn<WeatherForecast>>(
      (weather) => weather.value == null
          ? SizedBox.shrink()
          : [
              <Widget>[
                WeatherIcon.fromLegend(weather.value!.daily.state,
                    DateTime.parse(weather
                    .value!.daily.lastChanged)).assetImage
                /*'https://www.weatherbit.io/static/img/icons/c01d.png'*//*${weather
                .value
                  .daily.current!.weather!.first.icon}.png'*/
                    // .cachedImage()
                    .expanded(flex: 1),
                <Widget>[
                  [
                    '${weather.value!.daily.temperature!.toPrecision(1)}'
                        '\u00b0F'
                        .asText(style: Get.textTheme.headline2!),
                    hSpace(4.0),
                    [
                      '${weather.value!.daily.forecast!.first.temperature!
                          /*.toPrecision
                        (1)*/}'
                          '\u00b0F'
                          .asText(style: Get.textTheme.headline6!),
                      hSpace(8.0),
                      '${weather.value!.daily.forecast!.first.templow
                          /*.toPrecision(1)*/}'
  '\u00b0F'
                          .asText(style: Get.textTheme.headline6!),
                    ].column()
                  ]
                      .row(mainAxisAlignment: MainAxisAlignment.start)
                      .contain(padding: EdgeInsets.only(left: 4.0)),
                  weather.value!.daily.state./*weather!.first.description
                      .*/capitalize!
                      .asText(style: Get.textTheme.headline5)
                      .contain(padding: EdgeInsets.only(left: 4.0)),
                ]
                    .column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start)
                    .contain(padding: EdgeInsets.only(top: 16.0))
                    .expanded(flex: 2)
              ].row(crossAxisAlignment: CrossAxisAlignment.start),
              vSpace(4.0),
              HourlyWeatherView(
                weather: weather.value!.hourly,
              )
            ]
              .column(mainAxisSize: MainAxisSize.min)
              .contain(padding: EdgeInsets.all(8.0)) /*)*/,
      controller.weatherForecast);
}

class HourlyWeatherView extends GetView<HomeController> {
  final dateFormat = DateFormat('h a');
  final WeatherState weather;

  HourlyWeatherView({Key? key, required this.weather});

  @override
  Widget build(BuildContext context) => weather.forecast!
      .where((element) =>
          element.datetime!.isAfter(DateTime.now()))
      .map<Widget>((hourlyTime) => [
            '${hourlyTime.temperature}\u00b0F'
                .asText(style: Get.textTheme.headline6!),
            WeatherIcon.fromLegend(hourlyTime.condition!, hourlyTime
                .datetime!).assetImage
            /*'https://www.weatherbit.io/static/img/icons/c01d.png'*//*${hourlyTime
            .first
                .icon}.png'*/
                /*.cachedImage()*/,
            dateFormat
                .format(hourlyTime.datetime!/*
                    DateTime.fromMillisecondsSinceEpoch(hourlyTime.dt * 1000)*/)
                .asText(style: Get.textTheme.headline6!),
          ].column())
      .toList()
      .row(mainAxisAlignment: MainAxisAlignment.spaceEvenly)
      .scrollable(scrollDirection: Axis.horizontal)
      .contain(padding: EdgeInsets.all(4.0));
}
