class AllWeather {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  CurrentWeather? current;
  List<MinutelyWeather>? minutely;
  List<HourlyWeather>? hourly;
  List<DailyWeather>? daily;
  List<WeatherAlerts>? alerts;

  AllWeather(
      {required this.lat,
      required this.lon,
      required this.timezone,
      required this.timezoneOffset,
      this.current,
      this.minutely,
      this.hourly,
      this.daily,
      this.alerts});

  AllWeather.fromJson(Map<String, dynamic> json)
      : this(
            lat: json['lat'],
            lon: json['lon'],
            timezone: json['timezone'],
            timezoneOffset: json['timezone_offset'],
            current: json['current'] != null
                ? CurrentWeather.fromJson(json['current'])
                : null,
            minutely: (json['minutely'] as List<dynamic>?)
                ?.map((e) => MinutelyWeather.fromJson(e))
                .toList(),
            hourly: (json['hourly'] as List<dynamic>?)
                ?.map((e) => HourlyWeather.fromJson(e))
                .toList(),
            daily: (json['daily'] as List<dynamic>?)
                ?.map((e) => DailyWeather.fromJson(e))
                .toList(),
            alerts: (json['alerts'] as List<dynamic>?)
                ?.map((e) => WeatherAlerts.fromJson(e))
                .toList());

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'timezone': timezone,
        'timezone_offset': timezoneOffset,
        if (current != null) 'current': current!.toJson(),
        if (minutely != null)
          'minutely': minutely!.map((v) => v.toJson()).toList(),
        if (hourly != null) 'hourly': hourly!.map((v) => v.toJson()).toList(),
        if (daily != null) 'daily': daily!.map((v) => v.toJson()).toList(),
        if (alerts != null) 'alerts': alerts!.map((v) => v.toJson()).toList(),
      };
}

class CurrentWeather {
  int dt;
  DateTime sunrise;
  DateTime sunset;
  double temp;
  double feelsLike;
  double pressure;
  double humidity;
  double dewPoint;
  double uvi;
  double clouds;
  double visibility;
  double windSpeed;
  double? windGust;
  double windDeg;
  List<Weather>? weather;
  Volume? rain;
  Volume? snow;

  CurrentWeather(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.uvi,
      required this.clouds,
      required this.visibility,
      required this.windSpeed,
      this.windGust,
      required this.windDeg,
      this.weather,
      this.rain,
      this.snow});

  CurrentWeather.fromJson(Map<String, dynamic> json)
      : this(
            dt: json['dt'],
            sunrise: DateTime.fromMillisecondsSinceEpoch(
                    (json['sunrise'] as int) * 1000,
                    isUtc: true)
                .toLocal(),
            sunset: DateTime.fromMillisecondsSinceEpoch(
                    (json['sunset'] as int) * 1000,
                    isUtc: true)
                .toLocal(),
            temp: json['temp'],
            feelsLike: json['feels_like'],
            pressure: json['pressure'],
            humidity: json['humidity'],
            dewPoint: json['dew_point'],
            uvi: json['uvi'],
            clouds: json['clouds'],
            visibility: json['visibility'],
            windSpeed: json['wind_speed'],
            windGust: json['wind_gust'],
            windDeg: json['wind_deg'],
            rain: json['rain'] != null ? Volume.fromJson(json['rain']) : null,
            snow: json['snow'] != null ? Volume.fromJson(json['snow']) : null,
            weather: json['weather'] != null
                ? (json['weather'] as List<dynamic>)
                    .map((e) => Weather.fromJson(e))
                    .toList()
                : null);

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunrise': sunrise.toUtc().millisecondsSinceEpoch / 1000,
        'sunset': sunset.toUtc().millisecondsSinceEpoch / 1000,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        if (windGust != null) 'wind_gust': windGust,
        'wind_deg': windDeg,
        if (weather != null)
          'weather': weather!.map((v) => v.toJson()).toList(),
        if (rain != null) 'rain': rain!.toJson(),
        if (snow != null) 'snow': snow!.toJson()
      };
}

const weatherCodeMappings = {
  200: 't01',
  201: 't02',
  202: 't03',
  210: 't01',
  211: 't02',
  212: 't03',
  221: 't05',
  230: 't04',
  231: 't04',
  232: 't04',
  300: 'd01',
  301: 'd02',
  302: 'd03',
  310: 'd01',
  311: 'd02',
  312: 'd03',
  313: 'r05',
  314: 'r06',
  321: 'r05',
  500: 'r01',
  501: 'r02',
  502: 'r03',
  503: 'r03',
  504: 'r03',
  511: 'f01',
  520: 'r04',
  521: 'r05',
  522: 'r06',
  531: 'r05',
  600: 's01',
  601: 's02',
  602: 's03',
  611: 's05',
  612: 's05',
  613: 's05',
  615: 's04',
  616: 's04',
  620: 's01',
  621: 's01',
  622: 's02',
  701: 'a01',
  711: 'a02',
  721: 'a03',
  731: 'a04',
  741: 'a05',
  751: 'a04',
  761: 'a04',
  762: 'a02',
  771: 'a03',
  781: 'a03',
  800: 'c01',
  801: 'c02',
  802: 'c02',
  803: 'c03',
  804: 'c04',
};

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather(
      {required this.id,
      required this.main,
      required this.description,
      required this.icon});

  Weather.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            main: json['main'],
            description: json['description'],
            icon:
                '${weatherCodeMappings[json['id']]}${(json['icon'] as String).endsWith('d') ? 'd' : 'n'}');

  Map<String, dynamic> toJson() =>
      {'id': id, 'main': main, 'description': description, 'icon': icon};
}

class Volume {
  double d1h;

  Volume({required this.d1h});

  Volume.fromJson(Map<String, dynamic> json) : this(d1h: json['1h']);

  Map<String, dynamic> toJson() => {'1h': d1h};
}

class MinutelyWeather {
  int dt;
  double precipitation;

  MinutelyWeather({required this.dt, required this.precipitation});

  MinutelyWeather.fromJson(Map<String, dynamic> json)
      : this(dt: json['dt'], precipitation: json['precipitation']);

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'precipitation': precipitation,
      };
}

class HourlyWeather {
  int dt;
  double temp;
  double feelsLike;
  double pressure;
  double humidity;
  double dewPoint;
  double uvi;
  double clouds;
  double visibility;
  double windSpeed;
  double windDeg;
  double? windGust;
  List<Weather>? weather;
  double pop;
  Volume? rain;
  Volume? snow;

  HourlyWeather(
      {required this.dt,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.uvi,
      required this.clouds,
      required this.visibility,
      required this.windSpeed,
      required this.windDeg,
      this.windGust,
      this.weather,
      required this.pop,
      this.rain,
      this.snow});

  HourlyWeather.fromJson(Map<String, dynamic> json)
      : this(
            dt: json['dt'],
            temp: json['temp'],
            feelsLike: json['feels_like'],
            pressure: json['pressure'],
            humidity: json['humidity'],
            dewPoint: json['dew_point'],
            uvi: json['uvi'],
            clouds: json['clouds'],
            visibility: json['visibility'],
            windSpeed: json['wind_speed'],
            windDeg: json['wind_deg'],
            windGust: json['wind_gust'],
            weather: (json['weather'] as List<dynamic>?)
                ?.map((e) => Weather.fromJson(e))
                .toList(),
            pop: json['pop'],
            rain: json['rain'] != null ? Volume.fromJson(json['rain']) : null,
            snow: json['snow'] != null ? Volume.fromJson(json['snow']) : null);

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        if (windGust != null) 'wind_gust': windGust,
        if (weather != null)
          'weather': weather!.map((v) => v.toJson()).toList(),
        'pop': pop,
        if (rain != null) 'rain': rain!.toJson(),
        if (snow != null) 'snow': snow!.toJson()
      };
}

class DailyWeather {
  int dt;
  DateTime sunrise;
  DateTime sunset;
  int moonrise;
  int moonset;
  double moonPhase;
  Temp temp;
  FeelsLike feelsLike;
  double pressure;
  double humidity;
  double dewPoint;
  double windSpeed;
  double? windGust;
  double windDeg;
  List<Weather>? weather;
  double clouds;
  double pop;
  double? rain;
  double? snow;
  double uvi;

  DailyWeather(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.moonrise,
      required this.moonset,
      required this.moonPhase,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.windSpeed,
      this.windGust,
      required this.windDeg,
      this.weather,
      required this.clouds,
      required this.pop,
      this.rain,
      this.snow,
      required this.uvi});

  DailyWeather.fromJson(Map<String, dynamic> json)
      : this(
          dt: json['dt'],
          sunrise: DateTime.fromMillisecondsSinceEpoch(
                  (json['sunrise'] as int) * 1000,
                  isUtc: true)
              .toLocal(),
          sunset: DateTime.fromMillisecondsSinceEpoch(
                  (json['sunset'] as int) * 1000,
                  isUtc: true)
              .toLocal(),
          moonrise: json['moonrise'],
          moonset: json['moonset'],
          moonPhase: json['moon_phase'],
          temp: Temp.fromJson(json['temp']),
          feelsLike: FeelsLike.fromJson(json['feels_like']),
          pressure: json['pressure'],
          humidity: json['humidity'],
          dewPoint: json['dew_point'],
          windSpeed: json['wind_speed'],
          windGust: json['wind_gust'],
          windDeg: json['wind_deg'],
          weather: (json['weather'] as List<dynamic>?)
              ?.map((e) => Weather.fromJson(e))
              .toList(),
          clouds: json['clouds'],
          pop: json['pop'],
          rain: json['rain'],
          snow: json['snow'],
          uvi: json['uvi'],
        );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunrise': sunrise.toUtc().millisecondsSinceEpoch / 1000,
        'sunset': sunset.toUtc().millisecondsSinceEpoch / 1000,
        'moonrise': moonrise,
        'moonset': moonset,
        'moon_phase': moonPhase,
        'temp': temp.toJson(),
        'feels_like': feelsLike.toJson(),
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'wind_speed': windSpeed,
        if (windGust != null) 'wind_gust': windGust,
        'wind_deg': windDeg,
        if (weather != null)
          'weather': weather!.map((v) => v.toJson()).toList(),
        'clouds': clouds,
        'pop': pop,
        if (rain != null) 'rain': rain,
        if (snow != null) 'snow': snow,
        'uvi': uvi,
      };
}

class Temp {
  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  Temp(
      {required this.day,
      required this.min,
      required this.max,
      required this.night,
      required this.eve,
      required this.morn});

  Temp.fromJson(Map<String, dynamic> json)
      : this(
          day: json['day'],
          min: json['min'],
          max: json['max'],
          night: json['night'],
          eve: json['eve'],
          morn: json['morn'],
        );

  Map<String, dynamic> toJson() => {
        'day': day,
        'min': min,
        'max': max,
        'night': night,
        'eve': eve,
        'morn': morn,
      };
}

class FeelsLike {
  double day;
  double night;
  double eve;
  double morn;

  FeelsLike(
      {required this.day,
      required this.night,
      required this.eve,
      required this.morn});

  FeelsLike.fromJson(Map<String, dynamic> json)
      : this(
          day: json['day'],
          night: json['night'],
          eve: json['eve'],
          morn: json['morn'],
        );

  Map<String, dynamic> toJson() => {
        'day': day,
        'night': night,
        'eve': eve,
        'morn': morn,
      };
}

class WeatherAlerts {
  String senderName;
  String event;
  int start;
  int end;
  String description;
  List<String>? tags;

  WeatherAlerts(
      {required this.senderName,
      required this.event,
      required this.start,
      required this.end,
      required this.description,
      this.tags});

  WeatherAlerts.fromJson(Map<String, dynamic> json)
      : this(
          senderName: json['sender_name'],
          event: json['event'],
          start: json['start'],
          end: json['end'],
          description: json['description'],
          tags: (json['tags'] as List<dynamic>).cast<String>(),
        );

  Map<String, dynamic> toJson() => {
        'sender_name': senderName,
        'event': event,
        'start': start,
        'end': end,
        'description': description,
        if (tags != null) 'tags': tags,
      };
}
