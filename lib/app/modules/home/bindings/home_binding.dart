import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/providers/weather_provider.dart';
import 'package:ha_hub/constants.dart';
import 'package:hassio_api/hassio_api.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<WeatherProvider>(() => WeatherProvider());
    Get.lazyPut<DateFormat>(() => DateFormat('EEE, MMMM d'), tag: 'dateFormat');
    Get.lazyPut<DateFormat>(() => DateFormat('h:mm'), tag: 'timeFormat');
    Get.lazyPut<DateFormat>(() => DateFormat(':ss'), tag: 'secondsFormat');
    Get.lazyPut<DateFormat>(() => DateFormat(' a'), tag: 'daySplitFormat');
    Get.lazyPut<HassIO>(() => HassIO(
        token: hassioToken,
        serverHost: 'condo-homeassistant.duckdns.org',
        ssl: true));
  }
}
