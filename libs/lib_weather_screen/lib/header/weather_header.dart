
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:lib_weather_screen/header/weather_header_bloc.dart';

import '../weather_city_info.dart';


class WeatherHeaderStyle {
  WeatherHeaderStyle({
    required this.size,
    required this.tempTextStyle,
    required this.cityTextStyle,
    required this.separationCityTemp,
    required this.textFieldFillColor,
    required this.cursorColor,
    required this.textFieldPadding,
  });
  final Size size;
  final TextStyle tempTextStyle;
  final TextStyle cityTextStyle;
  final double separationCityTemp;
  final Color textFieldFillColor;
  final Color cursorColor;
  final EdgeInsets textFieldPadding;
}

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({
    Key? key, 
    required this.style, 
    required this.bloc,
    required this.onSubmitted,
    this.cityInfo,
  }) : super(key: key);

  final WeatherHeaderStyle style;
  final WeatherHeaderBLoC bloc;
  final WeatherCityInfo? cityInfo;
  final Function(String) onSubmitted;

  WeatherType _weatherIdToType(final int id) {
    if (id>=200 && id<=232) { // Tunderstorm
      return WeatherType.thunder;
    } else if (id>=300 && id<=321) { // Drizzle
      return WeatherType.lightRainy;
    } else if (id>=500 && id<=531) { // Rain
      if (id<=501) {
        return WeatherType.lightRainy;
      } else if (id<=511) {
        return WeatherType.middleRainy;
      } else {
        return WeatherType.heavyRainy;
      }
    } else if (id>=600 && id<=622) { // Snow
      if (id<=601) {
        return WeatherType.lightSnow;
      } else if (id<=612) {
        return WeatherType.middleSnow;
      } else {
        return WeatherType.heavySnow;
      }
    } else if (id>=701 && id<=781) { // Athmosfere
      if (id<=721) {
        return WeatherType.hazy;
      } else if (id==741) {
        return WeatherType.foggy;
      } else {
        return WeatherType.dusty;
      }
    } else if (id==800) { // Clear
      return WeatherType.sunny;
    } else if (id>=801 && id<=804) { // Clouds|
      return WeatherType.cloudy;
    }
    return WeatherType.sunny;
  }

  Widget _buildTextField(final BuildContext context) {
    return TextField(
      controller: bloc.editingController, 
      focusNode: FocusNode(), 
      decoration: InputDecoration(
        fillColor: style.textFieldFillColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid
          )
        ),
        hintText: 'Enter a location',
      ),
      style: style.cityTextStyle,
      cursorColor: style.cursorColor, 
      onSubmitted: onSubmitted,
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.size.width,
      height: style.size.height,
      child: Stack(
        children: [
          WeatherBg(
            weatherType: _weatherIdToType(cityInfo?.weather.entries.first.weatherId ?? 0), 
            width: style.size.width, 
            height: style.size.height
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text(
                    (cityInfo!=null ? '${cityInfo?.weather.entries.first.temp}' : '?') + ' °C', 
                    style: style.tempTextStyle,
                  ),
                  Container(height: style.separationCityTemp),
                  Padding(
                    padding: style.textFieldPadding,
                    child: _buildTextField(context),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

}