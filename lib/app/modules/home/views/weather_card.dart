import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => ObxValue<Rx<AllWeather>>(
      (weather) => Card(
          child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
                  Expanded(
                      flex: 1,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://www.weatherbit.io/static/img/icons/${weather.value.current!.weather!.first.icon}.png',
                        fit: BoxFit.fill,
                        placeholder: (_, __) => CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => Icon(Icons.error),
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              '${weather.value.current!.temp.toPrecision(1)}\u00b0F',
                                              style: Get.textTheme.headline2!
                                                  .copyWith(
                                                      // color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      letterSpacing: -1.5)),
                                          SizedBox(width: 4.0),
                                          Column(children: <Widget>[
                                            Text(
                                                '${weather.value.daily!.first.temp.max.toPrecision(1)}\u00b0F',
                                                style: Get.textTheme.headline6!
                                                    .copyWith(
                                                        letterSpacing: -1.5)),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                                '${weather.value.daily!.first.temp.min.toPrecision(1)}\u00b0F',
                                                style: Get.textTheme.headline6!
                                                    .copyWith(
                                                        letterSpacing: -1.5,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                          ])
                                        ])),
                                Container(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        weather.value.current!.weather!.first
                                            .description.capitalize!,
                                        style: Get.textTheme.headline5)),
                              ])))
                ]),
                SizedBox(height: 4.0),
                HourlyWeatherView(
                  weather: weather.value,
                )
              ]))),
      controller.allWeather);
}

class HourlyWeatherView extends GetView<HomeController> {
  final dateFormat = DateFormat('h a');
  final AllWeather weather;

  HourlyWeatherView({Key? key, required this.weather});

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(4.0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weather.hourly!
                  .where((element) =>
                      element.dt * 1000 > DateTime.now().millisecondsSinceEpoch)
                  // .take(4)
                  .map<Widget>((hourlyTime) => Column(children: <Widget>[
                        Text('${hourlyTime.temp.toPrecision(1)}\u00b0F',
                            style: Get.textTheme.headline6!
                                .copyWith(letterSpacing: -1.5)),
                        // SizedBox(height: 2.0),
                        CachedNetworkImage(
                          imageUrl:
                              'https://www.weatherbit.io/static/img/icons/${hourlyTime.weather!.first.icon}.png',
                          fit: BoxFit.fill,
                          placeholder: (_, __) => CircularProgressIndicator(),
                          errorWidget: (_, __, ___) => Icon(Icons.error),
                        ),
                        // SizedBox(height: 2.0),
                        Text(
                            dateFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    hourlyTime.dt * 1000)),
                            style: Get.textTheme.headline6!
                                .copyWith(letterSpacing: -1.5)),
                      ]))
                  .toList())));
}
