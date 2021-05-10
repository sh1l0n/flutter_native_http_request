//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

import 'api/common.dart';
import 'api/weather_api.dart';

class WeatherDayCardStyle {
  const  WeatherDayCardStyle({
    required this.size,
    required this.separationIconInfo,
    required this.tempTextStyle,
    required this.dateTextStyle,
    required this.transparentLayerColor,
    required this.separationTempRight,
  });
  final Size size;
  final double separationIconInfo;
  final TextStyle tempTextStyle;
  final TextStyle dateTextStyle;
  final Color transparentLayerColor;
  final double separationTempRight;
}

class WeatherDayCard extends StatelessWidget {
  const WeatherDayCard({
    Key? key,
    required this.style,
    required this.weather,
  });
  final OneCallResponseEntry weather;
  final WeatherDayCardStyle style;

  String _intToWeekDay(final int weekday) {
    switch(weekday) {
      case DateTime.monday: return 'Mon';
      case DateTime.tuesday: return 'Tue';
      case DateTime.wednesday: return 'Wed';
      case DateTime.thursday: return 'Thu';
      case DateTime.friday: return 'Fri';
      case DateTime.saturday: return 'Sat';
      case DateTime.sunday: return 'Sun';
      default: return 'Mon';
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);

    return Container(
      child: Stack(
        children: [
           WeatherBg(
            weatherType: weatherIdToType(weather.weatherId), 
            width: style.size.width, 
            height: style.size.height,
          ),
          Container(
            width: style.size.width, 
            height: style.size.height,
            color: style.transparentLayerColor,
          ),
          Row(
            children: [
              Center(
                child: Image.network(
                  'https://openweathermap.org/img/w/${weather.icon}.png',
                ),
              ),
              Container(width: style.separationIconInfo),
              Text(
                _intToWeekDay(date.weekday) + ' ' + date.day.toString(),
                style: style.dateTextStyle,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: style.separationTempRight),
              child: Text(
                weather.temp.toInt().toString() + '°C',
                style: style.tempTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}