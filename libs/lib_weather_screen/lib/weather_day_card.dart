//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

import 'common.dart';
import 'weather_api.dart';

class WeatherDayCardStyle {
  const  WeatherDayCardStyle({
    required this.size
  });
  final Size size;
}

class WeatherDayCard extends StatelessWidget {
  const WeatherDayCard({
    Key? key,
    required this.style,
    required this.weather,
  });
  final OneCallResponseEntry weather;
  final WeatherDayCardStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
           WeatherBg(
            weatherType: weatherIdToType(weather.weatherId), 
            width: style.size.width, 
            height: style.size.height,
          )
        ],
      ),
    );
  }
}