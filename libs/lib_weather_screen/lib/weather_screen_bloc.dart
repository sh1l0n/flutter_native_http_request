//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http_request/http_request.dart';
import 'package:lib_location/location.dart';

import 'weather_api.dart';

class WeatherCityInfo {
  const WeatherCityInfo(this.city, this.weather);
  final CityInfo? city;
  final OneCallResponse weather;  

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
    'city': city,
    'weather': weather,
  };
}

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

  Future<WeatherCityInfo?> getWeatherFromAddress(final String address) async {
    final city = await LocationManager.getCityFromAddress(address);
    return _getWeatherIn(city);
  }

  Future<WeatherCityInfo?> getWeatherCurrentLocation() async {
    final city = await requestCurrentLocation();
    return city!=null ? await _getWeatherIn(city) : null;
  }

  Future<String> getIcon(final String icon) async {
    final response = await HttpRequest.get(
      'https://openweathermap.org/img/w/$icon.png'
    );
    return response;
  }

  Future<WeatherCityInfo?> _getWeatherIn(final CityInfo location) async {
    try {
      final apiKey = await _getApiKey();

      final response = await HttpRequest.get(
        'https://api.openweathermap.org/data/2.5/onecall',
        params: {
          'lat': location.latitude.toString(), 
          'lon': location.longitude.toString(),
          'apiKey': apiKey,
          'units': 'metric',
          'exclude': 'minutely,hourly',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response);
      if(!data.containsKey('error')) {
        final oneCallResponse = OneCallResponse.fromJson(data);
        final city = await LocationManager.getCityFromCoordinates(oneCallResponse.latitude, oneCallResponse.longitude);
        return WeatherCityInfo(
          city,
          oneCallResponse,
        );
      }
    } on PlatformException {}
    _sendMessageToClient('Cannot retrive weather info for selected location');
    return null;
  }

  Future<CityInfo?> requestCurrentLocation() async {
    final permissionStatus = await LocationManager.requestLocationPermission();
    if (LocationPermissionStatusHelper.isGranted(permissionStatus)) {
      final toggleOn = await LocationManager.requestLocationToggleOn();
      if (toggleOn) {
        return await LocationManager.requestCurrentLocation();
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