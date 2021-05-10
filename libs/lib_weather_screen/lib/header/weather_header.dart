//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:lib_weather_screen/api/weather_api.dart';

import 'weather_header_bloc.dart';
import '../api/weather_city_info.dart';

class WeatherHeaderStyle {
  WeatherHeaderStyle({
    required this.size,
    required this.tempTextStyle,
    required this.cityTextStyle,
    required this.separationCityTemp,
    required this.textFieldFillColor,
    required this.cursorColor,
    required this.textFieldPadding,
    required this.useMyLocationTextStyle,
    required this.legendStyle,
    required this.legendPadding,
    required this.transparentLayerColor,
  });
  final Size size;
  final TextStyle tempTextStyle;
  final TextStyle cityTextStyle;
  final double separationCityTemp;
  final Color textFieldFillColor;
  final Color cursorColor;
  final EdgeInsets textFieldPadding;
  // ##TODO: This attribute is a colored layer over the weather background in order to make text more visible
  // the cards is also using it. It needs a refactoring process for unifying that configuration.
  final Color transparentLayerColor;
  final TextStyle useMyLocationTextStyle;
  final TextStyle legendStyle;
  final EdgeInsets legendPadding;
}

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({
    Key? key, 
    required this.style, 
    required this.bloc,
    required this.onSubmitted,
    required this.didUseMyLocationPressed,
    this.cityInfo,
  }) : super(key: key);

  final WeatherHeaderStyle style;
  final WeatherHeaderBLoC bloc;
  final WeatherCityInfo? cityInfo;
  final Function(String) onSubmitted;
  final Function() didUseMyLocationPressed;

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
    bloc.editingController.text = bloc.text;
  
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
      textAlign: TextAlign.center,
      style: style.cityTextStyle,
      cursorColor: style.cursorColor, 
      onSubmitted: onSubmitted,
      onEditingComplete: () {
        onSubmitted(bloc.text);
      },
    );
  }

  String _getCityFullPath() {
    final city = cityInfo?.city;
    if (city==null) {
      return '';
    }
    final values = [
      city.postalCode ?? '',
      city.locality ?? '',
      city.subAdministrativeArea ?? '',
      city.country ?? '',
    ];
    var res = '';
    for (var i=0; i<values.length; i++) {
      if (values[i]!='') {
        res += values[i];
      }
      if (i<values.length-1) {
        res += ', ';
      }
    }
    return res;
  }

  Widget _buildTemp(final BuildContext context) {
    if (cityInfo==null) {
      return Text('');
    } 

    final icon = cityInfo?.weather.entries[1].icon;
    final temp = Text(
      '${cityInfo?.weather.entries.first.temp.toInt()}°C',
      style: style.tempTextStyle,
    );

    if (icon==null) {
      return Center(child: temp);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        temp,
        Image.network(createImageUrl(icon),),
      ],
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
          Container(
            width: style.size.width, 
            height: style.size.height,
            color: style.transparentLayerColor,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTemp(context),
                Container(height: style.separationCityTemp),
                Padding(
                  padding: style.textFieldPadding,
                  child: _buildTextField(context),
                ),
                Container(height: style.separationCityTemp*0.5),
                TextButton(
                  style: ButtonStyle(
                    enableFeedback: true,
                  ),
                  child: Text(
                    'Use my location',
                    style: style.useMyLocationTextStyle,
                  ),
                  onPressed: didUseMyLocationPressed,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: style.legendPadding,
              child: Text(
                _getCityFullPath(),
                textAlign: TextAlign.center,
                style: style.legendStyle,
    
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            )
          )
        ],
      ),
    );
  }

}