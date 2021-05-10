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

import 'header/weather_header_bloc.dart';
import 'api/weather_api.dart';
import 'api/weather_city_info.dart';


class WeatherScreenBLoC {
  final StreamController<String> _messageToClientController = StreamController<String>.broadcast();
  Stream<String> get messageToClientStream => _messageToClientController.stream;
  Sink<String> get _messageToClientSink => _messageToClientController.sink;

  final StreamController<WeatherCityInfo?> _updateWeatherController = StreamController<WeatherCityInfo?>.broadcast();
  Stream<WeatherCityInfo?> get updateWeatherStream => _updateWeatherController.stream;
  Sink<WeatherCityInfo?> get _updateWeatherSink => _updateWeatherController.sink;


  final header = WeatherHeaderBLoC();

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

  Future<void> getWeatherFromAddress(final String address) async {
    final city = await LocationManager.getCityFromAddress(address);
    if (city==null) {
      _sendMessageToClient('Location not found');
    }
    final data = city!=null ? await _getWeatherIn(city) : null;
    _updateWeatherUI(data);
  }

  void _updateWeatherUI(final WeatherCityInfo? weather) {
    if (weather!=null && !_updateWeatherController.isClosed && _updateWeatherController.hasListener) {
      _updateWeatherSink.add(weather);
    }
  }

  Future<void> getWeatherCurrentLocation() async {
    final city = await requestCurrentLocation();
    final data = city!=null ? await _getWeatherIn(city) : null;
    _updateWeatherUI(data);
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
    _updateWeatherController.close();
  }

}