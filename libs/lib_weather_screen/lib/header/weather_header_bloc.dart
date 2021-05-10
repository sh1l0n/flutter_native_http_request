
import 'package:flutter/cupertino.dart';
import 'package:lib_weather_screen/weather_city_info.dart';

class WeatherHeaderBLoC {
  WeatherHeaderBLoC() {
    editingController.addListener(_textFieldListener);
  }

  final editingController = TextEditingController();

  String get text => _text;
  late String _text = ''; 

  void _textFieldListener() {
    print("listener: ${editingController.text}");
    _text = editingController.text;
    print("bloc.texttexttext; ${_text}");
  }

  void dispose() {
    editingController.removeListener(_textFieldListener);
    editingController.dispose();
  }
}