import 'package:flutter/material.dart';

import 'package:lib_weather_screen/weather_screen.dart';
import 'package:lib_weather_screen/weather_screen_bloc.dart';


// import 'package:lib_location/location.dart';

// ##DOC:
//https://pub.dev/packages/weather_widget
// ##Developing native pkg:
// https://github.com/flutter/flutter/issues/19830
// For running comment the flutter.jar import in build.gradle, but for editing be sure that its uncommented



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(
        bloc: WeatherScreenBLoC(), 
          style: WeatherScreenStyle(
            snackBarStyle: SnackBarStyle(
              textStyle: TextStyle(color: Color(0xffffffff)), 
              color: Color(0xff424242)
            )
          ),
        ),
      );
  }
}