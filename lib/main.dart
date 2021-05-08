import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http_request/http_request.dart';
import 'package:lib_location/location.dart';
// import 'package:lib_location/location.dart';

// ##DOC:
//https://pub.dev/packages/weather_widget
// ##Developing native pkg:
// https://github.com/flutter/flutter/issues/19830
// For running comment the flutter.jar import in build.gradle, but for editing be sure that its uncommented



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<String> getApiKey() async {
    final jsonData = await rootBundle.loadString('assets/env.json');
    final jsonResult = json.decode(jsonData);
    final secret = jsonResult['api_key'];
    return secret;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            LocationManager().requestLocationPermission().then((value) {
              print('requestLocationPermission: $value');
              if (!value) {
                return;
              }
              LocationManager().requestLocationToggleOn().then((value) {
                print('requestLocationToggleOn: $value');
                if (!value) {
                  return;
                }
                LocationManager().requestCurrentLocation().then((value) {
                  print('latitude: ${value?.latitude} longitude: ${value?.longitude}');
                });
              });
            });
          },
        ),
      ),
    );
  }
}
