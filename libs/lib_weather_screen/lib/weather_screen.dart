//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:lib_weather_screen/header/weather_header_bloc.dart';
import 'header/weather_header.dart';
import 'weather_screen_bloc.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

class SnackBarStyle {
  const SnackBarStyle({required this.textStyle, required this.color});
  final TextStyle textStyle;
  final Color color;
}

class WeatherScreenStyle {
  const WeatherScreenStyle({required this.snackBarStyle});
  final SnackBarStyle snackBarStyle;
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key, required this.bloc, required this.style}) : super(key: key);
  final WeatherScreenBLoC bloc;
  final WeatherScreenStyle style;

  void _buildSnackbar(final BuildContext context, final String title) {
    final snackBar = SnackBar(
      content: Text(title, style: style.snackBarStyle.textStyle),
      backgroundColor: style.snackBarStyle.color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  WeatherType _weatherIdToType(final int id) {
    if (id>=200 && id<=232) { // Tunderstorm
      return WeatherType.thunder;
    } else if (id>=300 && id<=321) { // Drizzle
      return WeatherType.lightRainy;
    } else if (id>=500 && id<=531) { // Rain
      if (id<=501) {
        return WeatherType.lightRainy;
      } else if (id<=511) {
        return WeatherType.middleRainy;
      } else {
        return WeatherType.heavyRainy;
      }
    } else if (id>=600 && id<=622) { // Snow
      if (id<=601) {
        return WeatherType.lightSnow;
      } else if (id<=612) {
        return WeatherType.middleSnow;
      } else {
        return WeatherType.heavySnow;
      }
    } else if (id>=701 && id<=781) { // Athmosfere
      if (id<=721) {
        return WeatherType.hazy;
      } else if (id==741) {
        return WeatherType.foggy;
      } else {
        return WeatherType.dusty;
      }
    } else if (id==800) { // Clear
      return WeatherType.sunny;
    } else if (id>=801 && id<=804) { // Clouds|
      return WeatherType.cloudy;
    }
    return WeatherType.sunny;
  }

  @override
  Widget build(final BuildContext context) {
    bloc.messageToClientStream.listen((message) {
      _buildSnackbar(context, message);
    });
    return Scaffold(
        appBar: AppBar(
        title: const Text('Flutter weather'),
      ),
      body: Center(
        child: Column(
          children: [
            WeatherHeader(
              bloc: bloc.header,
              style: WeatherHeaderStyle(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height*0.35,
                ),
                cityTextStyle: TextStyle(fontSize: 25),
                tempTextStyle: TextStyle(fontSize: 40),
                useMyLocationTextStyle: TextStyle(
                  fontSize: 20,
                  color: Color(0xff242424),
                ),
                separationCityTemp: 5,
                textFieldFillColor: Color(0x33424242),
                cursorColor: Color(0xff424242),
                textFieldPadding: EdgeInsets.symmetric(horizontal: 5),
              ),
              onSubmitted: (final String value) {
                bloc.getWeatherFromAddress(value).then((value) {
                  print(value);
                });
              },
              didUseMyLocationPressed: () {
                bloc.getWeatherCurrentLocation().then((value) {
                  print(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}