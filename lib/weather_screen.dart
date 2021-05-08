

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_request/http_request.dart';
import 'package:lib_location/location.dart';

class WeatherScreenBLoC {

  Future<String> getApiKey() async {
    final jsonData = await rootBundle.loadString('assets/env.json');
    final jsonResult = json.decode(jsonData);
    final secret = jsonResult['api_key'];
    return secret;
  }

  Future<void> getWeather() async {
     try {
      final apiKey = await getApiKey();
      final x = await HttpRequest.get(
        'https://api.openweathermap.org/data/2.5/weather',
        params: {'q': 'Alicante, Spain', 'apikey': apiKey},
      );
      print('RESPONSE HTTP: $x');
    } on PlatformException {
    }
  }


}

class WeatherScreenStyle {

}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key, required this.bloc, required this.style}) : super(key: key);

  final WeatherScreenBLoC bloc;
  final WeatherScreenStyle style;

  void _buildSnackbar(final BuildContext context, final String title) {
    final snackBar = SnackBar(
      content: Text(title),
      // backgroundColor: style.snackBarColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

   Future<LocationInfo?> checkLocation(final BuildContext context) async {

    final permissionStatus = await LocationManager().requestLocationPermission();
    print("permissionStatus: $permissionStatus");

    if (LocationPermissionStatusHelper.isGranted(permissionStatus)) {
      final toggleOn = await LocationManager().requestLocationToggleOn();
      if (toggleOn) {
        return await LocationManager().requestCurrentLocation();
      }
      _buildSnackbar(context, 'GPS should be enabled in order to discover your position');
    } else if (LocationPermissionStatusHelper.isDeniedForever(permissionStatus)) {
      _buildSnackbar(context, 'Location Permission is denied forever. Please go to settings and activate Location Permission for this app');
    } else if (LocationPermissionStatusHelper.isDenied(permissionStatus)) {
      _buildSnackbar(context, 'Location Permission must be granted in order to use GPS');
    } 
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text('Running on\n'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkLocation(context).then((value) {
            print('current location: $value');
          });
        }
      )
    );
  }
  

}