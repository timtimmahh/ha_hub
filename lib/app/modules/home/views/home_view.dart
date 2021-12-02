import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:ha_hub/app/modules/home/views/weather_card.dart';
import 'package:ha_hub/app/views/getx_future_view.dart';

import '../controllers/home_controller.dart';
import 'time_card.dart';

class HomeView extends GetView<HomeController> {
  HomeView();

  HomeView.forDesignTime();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(24.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 3, child: TimeCard()),
                  Expanded(
                      flex: 4,
                      child: GetXFutureView<HomeController, AllWeather?>(
                          rxFuture: controller.allWeatherFuture,
                          builder: (weather) => WeatherCard()))
                ])));
  }
}
