import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';

class WeatherProvider extends GetConnect {
  static const _appId = '17ffa78a3cdc76eca2be9679435c53ba';

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.allorigins.win/raw';
  }

  Future<AllWeather> getWeatherData(double lat, double lon,
          {List<String>? excludes = const ['minutely'],
          String units = 'imperial',
          String lang = 'en'}) async =>
      await get('',
              query: {
                'url':
                    'https://api.openweathermap.org/data/2.5/onecall?lat=${lat.toPrecision(4)}&lon=${lon.toPrecision(4)}&appid=$_appId&units=$units&lang=$lang${excludes == null ? '' : '&exclude=${excludes.join(',')}'}'
              },
              decoder: (json) => AllWeather.fromJson(json))
          .then((value) => value.body!);
}
