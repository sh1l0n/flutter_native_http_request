import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http_request/http_request.dart';
import 'package:lib_location/location.dart';

class WeatherScreenBLoC {
  StreamController<String> _messageToClientController = StreamController<String>.broadcast();
  Stream<String> get messageToClientStream => _messageToClientController.stream;
  Sink<String> get _messageToClientSink => _messageToClientController.sink;

  Future<String> _getApiKey() async {
    final jsonData = await rootBundle.loadString('assets/env.json');
    final jsonResult = json.decode(jsonData);
    final secret = jsonResult['api_key'];
    return secret;
  }

  void _sendMessageToClient(final String message) {
    if(!_messageToClientController.isClosed && _messageToClientController.hasListener) {
      _messageToClientSink.add(message);
    }
  }

  Future<void> getWeatherCurrentLocation(final LocationInfo location) async {
    try {
      final apiKey = await _getApiKey();
      final x = await HttpRequest.get(
        'https://api.openweathermap.org/data/2.5/weather',
        params: {'lat': location.latitude.toString(), 'lon': location.longitude.toString(), 'apikey': apiKey},
      );
      print('RESPONSE HTTP: $x');
    } on PlatformException {
    }
  }

  Future<void> getWeather() async {
     try {
      final apiKey = await _getApiKey();
      final x = await HttpRequest.get(
        'https://api.openweathermap.org/data/2.5/weather',
        params: {'q': 'Alicante, Spain', 'apikey': apiKey},
      );
      print('RESPONSE HTTP: $x');
    } on PlatformException {
    }
  }

  Future<LocationInfo?> checkLocation() async {
    final permissionStatus = await LocationManager.requestLocationPermission();
    if (LocationPermissionStatusHelper.isGranted(permissionStatus)) {
      final toggleOn = await LocationManager.requestLocationToggleOn();
      if (toggleOn) {
        final x = await LocationManager.requestCurrentLocation();
        print(x);
        return x;
      }
      _sendMessageToClient('GPS should be enabled in order to discover your position');
    } else if (LocationPermissionStatusHelper.isDeniedForever(permissionStatus)) {
      _sendMessageToClient('Location Permission is denied forever. Please go to settings and activate Location Permission for this app');
    } else if (LocationPermissionStatusHelper.isDenied(permissionStatus)) {
      _sendMessageToClient('Location Permission must be granted in order to use GPS');
    } 
    return null;
  }

  void dispose() {
    _messageToClientController.close();
  }
}