//
// Created by @sh1l0n
//
// Licensed by GPLv3
//


import 'package:flutter/material.dart';

import 'package:lib_weather_screen/header/weather_header.dart';
import 'package:lib_weather_screen/weather_day_card.dart';
import 'package:lib_weather_screen/weather_screen.dart';
import 'package:lib_weather_screen/weather_screen_bloc.dart';


// import 'package:lib_location/location.dart';

// ##DOC:
//https://pub.dev/packages/weather_widget
// ##Developing native pkg:
// https://github.com/flutter/flutter/issues/19830
// For running comment the flutter.jar import in build.gradle, but for editing be sure that its uncommented



void main() {
  runApp(_AppHelper());
}

// Trick for make context available inside MaterialApp and be able to edit styles
class _AppHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MyApp(),
    );
  }
}

class _MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WeatherScreen(
      bloc: WeatherScreenBLoC(), 
      style: WeatherScreenStyle(
        snackBarStyle: SnackBarStyle(
          textStyle: TextStyle(
            color: Color(0xffffffff),
          ), 
          color: Color(0xff424242),
        ),
        header: WeatherHeaderStyle(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height*0.4,
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
          legendStyle: TextStyle(
            fontSize: 16, 
            color: Color(0xffffffff),
            backgroundColor: Color(0x66424242),
          ),
          legendPadding: EdgeInsets.only(bottom: 3),
        ), 
        card: WeatherDayCardStyle(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height*0.15,
          )
        ),
      ),
    );
  }
}