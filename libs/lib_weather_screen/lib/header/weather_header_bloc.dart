
import 'package:flutter/cupertino.dart';
import 'package:lib_weather_screen/weather_city_info.dart';

class WeatherHeaderBLoC {
  WeatherHeaderBLoC();

  final editingController = TextEditingController();
  String get text => editingController.text;

  void dispose() {
    editingController.dispose();
  }
}