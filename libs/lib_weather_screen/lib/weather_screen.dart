//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';

import 'api/weather_city_info.dart';
import 'header/weather_header.dart';
import 'weather_day_card.dart';
import 'weather_screen_bloc.dart';

class SnackBarStyle {
  const SnackBarStyle({required this.textStyle, required this.color});
  final TextStyle textStyle;
  final Color color;
}

class AppBarStyle {
  const AppBarStyle({
    required this.color, 
    required this.textStyle, 
    required this.height
  });

  final Color color;
  final TextStyle textStyle;
  final double height;
}

class WeatherScreenStyle {
  const WeatherScreenStyle({
    required this.snackBarStyle,
    required this.appBar,
    required this.header,
    required this.card,
    required this.noLocationSelectedTextStyle,
    required this.separatorColor,
  });
  final SnackBarStyle snackBarStyle;
  final AppBarStyle appBar;
  final TextStyle noLocationSelectedTextStyle;
  final Color separatorColor;
  final WeatherHeaderStyle header;
  final WeatherDayCardStyle card;
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

  Widget _buildHeader(final BuildContext context, final WeatherCityInfo? cityInfo) {
    return WeatherHeader(
      bloc: bloc.header,
      cityInfo: cityInfo,
      style: style.header,
      onSubmitted: (final String value) {
        bloc.getWeatherFromAddress(value);
      },
      didUseMyLocationPressed: () {
        bloc.getWeatherCurrentLocation();
      },
    );
  }

  Widget _buildWeekInfo(final BuildContext context, final WeatherCityInfo? cityInfo) {
    final itemExtent = MediaQuery.of(context).size.height*0.15;

    if (cityInfo==null) {
      return Center(
        child: Text(
          'No location selected',
          style: style.noLocationSelectedTextStyle,
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemExtent: itemExtent,
      itemBuilder: (final BuildContext context, final int index) {
        final entry = cityInfo.weather.entries[index+2];
        return WeatherDayCard(
          weather: entry,
          style: style.card,
        );
      },
      itemCount: cityInfo.weather.entries.length-2,
    );
  }

  Widget _buildContent(final BuildContext context, final WeatherCityInfo? cityInfo) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: _buildHeader(context, cityInfo),
        ),
        Container(height: 1, color: style.separatorColor),
        Expanded(
          flex: 6,
          child: _buildWeekInfo(context, cityInfo),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    bloc.messageToClientStream.listen((message) {
      _buildSnackbar(context, message);
    });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(style.appBar.height),
        child: AppBar(
          backgroundColor: style.appBar.color,
          title: Text(
            'Flutter Weather',
            style: style.appBar.textStyle,
          ),
        ), 
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        initialData: null,
        stream: bloc.updateWeatherStream,
        builder: (final BuildContext context, final AsyncSnapshot<WeatherCityInfo?> snp) {
          final data = snp.data;
          return _buildContent(context, data);
        }
      ),
    );
  }
}