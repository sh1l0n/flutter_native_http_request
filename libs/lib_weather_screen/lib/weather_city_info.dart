//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:lib_location/location.dart';
import 'weather_api.dart';

class WeatherCityInfo {
  const WeatherCityInfo(this.city, this.weather);
  final CityInfo? city;
  final OneCallResponse weather;  

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
    'city': city,
    'weather': weather,
  };
}
