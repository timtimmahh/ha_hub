import 'dart:convert';

import 'package:flutter/material.dart';

import 'weather_model.dart';

const String rawIconLegend = '{"clearsky":{"desc_en":"Clear sky","desc_nb":"Kla'
    'rvæ'
    'r","desc_nn":"Klårvêr","old_id":"1","variants":["day","night","polartwilight"]},"cloudy":{"desc_en":"Cloudy","desc_nb":"Skyet","desc_nn":"Skya","old_id":"4","variants":null},"fair":{"desc_en":"Fair","desc_nb":"Lettskyet","desc_nn":"Lettskya","old_id":"2","variants":["day","night","polartwilight"]},"fog":{"desc_en":"Fog","desc_nb":"Tåke","desc_nn":"Skodde","old_id":"15","variants":null},"heavyrain":{"desc_en":"Heavy rain","desc_nb":"Kraftig regn","desc_nn":"Kraftig regn","old_id":"10","variants":null},"heavyrainandthunder":{"desc_en":"Heavy rain and thunder","desc_nb":"Kraftig regn og torden","desc_nn":"Kraftig regn og torevêr","old_id":"11","variants":null},"heavyrainshowers":{"desc_en":"Heavy rain showers","desc_nb":"Kraftige regnbyger","desc_nn":"Kraftige regnbyer","old_id":"41","variants":["day","night","polartwilight"]},"heavyrainshowersandthunder":{"desc_en":"Heavy rain showers and thunder","desc_nb":"Kraftige regnbyger og torden","desc_nn":"Kraftige regnbyer og torevêr","old_id":"25","variants":["day","night","polartwilight"]},"heavysleet":{"desc_en":"Heavy sleet","desc_nb":"Kraftig sludd","desc_nn":"Kraftig sludd","old_id":"48","variants":null},"heavysleetandthunder":{"desc_en":"Heavy sleet and thunder","desc_nb":"Kraftig sludd og torden","desc_nn":"Kraftig sludd og torevêr","old_id":"32","variants":null},"heavysleetshowers":{"desc_en":"Heavy sleet showers","desc_nb":"Kraftige sluddbyger","desc_nn":"Kraftige sluddbyer","old_id":"43","variants":["day","night","polartwilight"]},"heavysleetshowersandthunder":{"desc_en":"Heavy sleet showers and thunder","desc_nb":"Kraftige sluddbyger og torden","desc_nn":"Kraftige sluddbyer og torevêr","old_id":"27","variants":["day","night","polartwilight"]},"heavysnow":{"desc_en":"Heavy snow","desc_nb":"Kraftig snø","desc_nn":"Kraftig snø","old_id":"50","variants":null},"heavysnowandthunder":{"desc_en":"Heavy snow and thunder","desc_nb":"Kraftig snø og torden","desc_nn":"Kraftig snø og torevêr","old_id":"34","variants":null},"heavysnowshowers":{"desc_en":"Heavy snow showers","desc_nb":"Kraftige snøbyger","desc_nn":"Kraftige snøbyer","old_id":"45","variants":["day","night","polartwilight"]},"heavysnowshowersandthunder":{"desc_en":"Heavy snow showers and thunder","desc_nb":"Kraftige snøbyger og torden","desc_nn":"Kraftige snøbyer og torevêr","old_id":"29","variants":["day","night","polartwilight"]},"lightrain":{"desc_en":"Light rain","desc_nb":"Lett regn","desc_nn":"Lett regn","old_id":"46","variants":null},"lightrainandthunder":{"desc_en":"Light rain and thunder","desc_nb":"Lett regn og torden","desc_nn":"Lett regn og torevêr","old_id":"30","variants":null},"lightrainshowers":{"desc_en":"Light rain showers","desc_nb":"Lette regnbyger","desc_nn":"Lette regnbyer","old_id":"40","variants":["day","night","polartwilight"]},"lightrainshowersandthunder":{"desc_en":"Light rain showers and thunder","desc_nb":"Lette regnbyger og torden","desc_nn":"Lette regnbyer og torevêr","old_id":"24","variants":["day","night","polartwilight"]},"lightsleet":{"desc_en":"Light sleet","desc_nb":"Lett sludd","desc_nn":"Lett sludd","old_id":"47","variants":null},"lightsleetandthunder":{"desc_en":"Light sleet and thunder","desc_nb":"Lett sludd og torden","desc_nn":"Lett sludd og torevêr","old_id":"31","variants":null},"lightsleetshowers":{"desc_en":"Light sleet showers","desc_nb":"Lette sluddbyger","desc_nn":"Lette sluddbyer","old_id":"42","variants":["day","night","polartwilight"]},"lightsnow":{"desc_en":"Light snow","desc_nb":"Lett snø","desc_nn":"Lett snø","old_id":"49","variants":null},"lightsnowandthunder":{"desc_en":"Light snow and thunder","desc_nb":"Lett snø og torden","desc_nn":"Lett snø og torevêr","old_id":"33","variants":null},"lightsnowshowers":{"desc_en":"Light snow showers","desc_nb":"Lette snøbyger","desc_nn":"Lette snøbyer","old_id":"44","variants":["day","night","polartwilight"]},"lightssleetshowersandthunder":{"desc_en":"Light sleet showers and thunder","desc_nb":"Lette sluddbyger og torden","desc_nn":"Lette sluddbyer og torevêr","old_id":"26","variants":["day","night","polartwilight"]},"lightssnowshowersandthunder":{"desc_en":"Light snow showers and thunder","desc_nb":"Lette snøbyger og torden","desc_nn":"Lette snøbyer og torevêr","old_id":"28","variants":["day","night","polartwilight"]},"partlycloudy":{"desc_en":"Partly cloudy","desc_nb":"Delvis skyet","desc_nn":"Delvis skya","old_id":"3","variants":["day","night","polartwilight"]},"rain":{"desc_en":"Rain","desc_nb":"Regn","desc_nn":"Regn","old_id":"9","variants":null},"rainandthunder":{"desc_en":"Rain and thunder","desc_nb":"Regn og torden","desc_nn":"Regn og torevêr","old_id":"22","variants":null},"rainshowers":{"desc_en":"Rain showers","desc_nb":"Regnbyger","desc_nn":"Regnbyer","old_id":"5","variants":["day","night","polartwilight"]},"rainshowersandthunder":{"desc_en":"Rain showers and thunder","desc_nb":"Regnbyger og torden","desc_nn":"Regnbyer og torevêr","old_id":"6","variants":["day","night","polartwilight"]},"sleet":{"desc_en":"Sleet","desc_nb":"Sludd","desc_nn":"Sludd","old_id":"12","variants":null},"sleetandthunder":{"desc_en":"Sleet and thunder","desc_nb":"Sludd og torden","desc_nn":"Sludd og torevêr","old_id":"23","variants":null},"sleetshowers":{"desc_en":"Sleet showers","desc_nb":"Sluddbyger","desc_nn":"Sluddbyer","old_id":"7","variants":["day","night","polartwilight"]},"sleetshowersandthunder":{"desc_en":"Sleet showers and thunder","desc_nb":"Sluddbyger og torden","desc_nn":"Sluddbyer og torevêr","old_id":"20","variants":["day","night","polartwilight"]},"snow":{"desc_en":"Snow","desc_nb":"Snø","desc_nn":"Snø","old_id":"13","variants":null},"snowandthunder":{"desc_en":"Snow and thunder","desc_nb":"Snø og torden","desc_nn":"Snø og torevêr","old_id":"14","variants":null},"snowshowers":{"desc_en":"Snow showers","desc_nb":"Snøbyger","desc_nn":"Snøbyer","old_id":"8","variants":["day","night","polartwilight"]},"snowshowersandthunder":{"desc_en":"Snow showers and thunder","desc_nb":"Snøbyger og torden","desc_nn":"Snøbyer og torevêr","old_id":"21","variants":["day","night","polartwilight"]}}';

const Map<String, String> knownAliases = {'sunny': 'clearsky'};

Map<String, dynamic> get iconLegend => json.decode(rawIconLegend);

class WeatherIcon {
  String key;
  String desc;
  String? variant;

  WeatherIcon({required this.key, required this.desc, this.variant});

  factory WeatherIcon.fromLegend(String state, DateTime forecastDate) {
    Map<String, dynamic> legend = iconLegend;
    Map<String, dynamic> iconInfo;
    if (knownAliases.containsKey(state)) {
      return WeatherIcon.fromLegend(knownAliases[state]!, forecastDate);
      // iconInfo = legend[knownAliases[state]];
    } else if (!legend.containsKey(state)) {
      return WeatherIcon.fromLegend('sunny', forecastDate);
    } else {
      iconInfo = legend[state];
    }
    if (iconInfo['variants'] != null &&
        (iconInfo['variants'] as List<dynamic>).isNotEmpty) {
      return WeatherIcon(
          key: state,
          desc: iconInfo['desc_en'],
          variant: forecastDate.hour > 6 && forecastDate.hour < 20
              ? 'day'
              : 'night');
    }
    return WeatherIcon(key: state, desc: iconInfo['desc_en']);
  }

  String get _assetName => variant == null ? '$key.png' : '${key}_$variant.png';

  Image get assetImage => Image.asset('icons/weather/$_assetName');
}
