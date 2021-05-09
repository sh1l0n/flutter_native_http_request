//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'weather_screen_bloc.dart';

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

  @override
  Widget build(final BuildContext context) {
    bloc.messageToClientStream.listen((message) {
      _buildSnackbar(context, message);
    });
    return Scaffold(
        appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            bloc.requestCurrentLocation().then((value) {
              if (value!=null) {
                bloc.getWeatherFromAddress('Alicante').then((value) {
                  print(value);
                });
                bloc.getWeatherCurrentLocation().then((value) {
                  print(value);
                });
              }
            });
          },
        ),
      ),
    );
  }
}