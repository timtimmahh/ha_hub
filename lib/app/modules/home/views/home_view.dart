import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';
import 'package:ha_hub/app/modules/home/views/weather_card.dart';
import 'package:ha_hub/app/views/getx_future_view.dart';
import 'package:ha_hub/exts/widget_exts.dart';

import '../controllers/home_controller.dart';
import 'time_card.dart';

class HomeView extends GetView<HomeController> {
  HomeView();

  HomeView.forDesignTime();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: [
      TimeCard().expanded(flex: 3),
      // GetXFutureView<HomeController, AllWeather?>(
      //     rxFuture: controller.allWeatherFuture, builder: (weather) => WeatherCard()).expanded(flex: 4)
    ].row(crossAxisAlignment: CrossAxisAlignment.start))
        .contain(padding: EdgeInsets.all(24.0));
  }
}
