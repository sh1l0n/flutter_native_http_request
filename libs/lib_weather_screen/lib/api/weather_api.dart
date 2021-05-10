//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

class OneCallResponseEntry {
  const OneCallResponseEntry(this.dt, this.temp, this.pressure, this.humidity, this.clouds, this.windSpeed, this.weatherId, this.title, this.description, this.icon);
  final int dt;
  final double temp;
  final double pressure;
  final double humidity;
  final double clouds;
  final double windSpeed;
  final int weatherId;
  final String title;
  final String description;
  final String icon;

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
    'dt': dt,
    'temp': temp,
    'pressure': pressure,
    'humidity': humidity,
    'clouds': clouds,
    'wind_speed': windSpeed,
    'weatherId': weatherId,
    'title': title,
    'description': description,
    'icon': icon
  };

  static double _parseNumberValue(final dynamic value) {
    var parsed = 0.0;
    try {
      parsed = value as double;
    } catch (e) {
      parsed = (value as int).toDouble();  
    }
    return parsed;
  }

  static OneCallResponseEntry fromJson(final Map<String, dynamic> data) {
    final dt = data['dt'] as int;
    late var temp = 0.0;
    if (data['temp'] is Map<String, dynamic>) {
      temp = _parseNumberValue(data['temp']['day']);
    } else {
      temp = _parseNumberValue(data['temp']);
    }

    final pressure = _parseNumberValue(data['pressure']);
    final humidity = _parseNumberValue(data['humidity']);
    final clouds = _parseNumberValue(data['clouds']);
    final windSpeed = _parseNumberValue(data['wind_speed']);
    final weather = data['weather'] as List<dynamic>;
    final weatherId = weather[0]['id'] as int;
    final title = weather[0]['main'] as String;
    final description = weather[0]['description'] as String;
    final icon = weather[0]['icon'] as String;
    return OneCallResponseEntry(dt, temp, pressure, humidity, clouds, windSpeed, weatherId, title, description, icon);
  } 
}

class OneCallResponse {
   const OneCallResponse(this.latitude, this.longitude, this.timezone, this.entries);

  final double latitude;
  final double longitude;
  final String  timezone;
  final List<OneCallResponseEntry> entries;

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
    'lat': latitude,
    'lon': longitude,
    'timezone': timezone,
    'entries': entries,
  };

  static OneCallResponse fromJson(final Map<String, dynamic> data) {
    final latitude = data['lat'] as double;
    final longitude = data['lon'] as double;
    final timezone = data['timezone'] as String;

    List<OneCallResponseEntry> entries = [];
    entries += [OneCallResponseEntry.fromJson(data['current'] as Map<String, dynamic>)];

    final dailys = data['daily'] as List<dynamic>;
    for (final entry in dailys) {
      final _entry = entry as Map<String, dynamic>;
      entries += [OneCallResponseEntry.fromJson(_entry)];
    }
    return OneCallResponse(latitude, longitude, timezone, entries);
  } 
}

String createImageUrl(final String imageId) {
  return 'https://openweathermap.org/img/w/${imageId}.png';
}