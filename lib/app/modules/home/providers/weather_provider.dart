import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/data/weather_model.dart';

class WeatherProvider extends GetConnect {
  static const _appId = '17ffa78a3cdc76eca2be9679435c53ba';

  @override
  void onInit() {
    httpClient.baseUrl =
        'http://192.168.1.226:8080/http://api.openweathermap.org/data/2.5';
  }

  Future<AllWeather> getWeatherData(double lat, double lon,
          {List<String>? excludes = const ['minutely'],
          String units = 'imperial',
          String lang = 'en'}) async =>
      await get('/onecall',
              query: {
                'lat': lat.toPrecision(4).toString(),
                'lon': lon.toPrecision(4).toString(),
                'appid': _appId,
                'units': units,
                'lang': lang,
                if (excludes != null) 'exclude': excludes.join(',')
              },
              decoder: (json) => AllWeather.fromJson(json))
          .then((value) => value.body!);
}
