//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/cupertino.dart';

class WeatherHeaderBLoC {
  WeatherHeaderBLoC() {
    editingController.addListener(_textFieldListener);
  }

  final editingController = TextEditingController();

  String get text => _text;
  late String _text = ''; 

  void _textFieldListener() {
    _text = editingController.text;
  }

  void dispose() {
    editingController.removeListener(_textFieldListener);
    editingController.dispose();
  }

  void cleanTextField() {
    editingController.clear();
  }
}