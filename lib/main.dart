import 'package:flutter/material.dart';

import 'weather_screen.dart';
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
        style: WeatherScreenStyle(),
      ),
    );
  }
}