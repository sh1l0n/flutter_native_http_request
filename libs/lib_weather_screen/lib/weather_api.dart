

class OneCallResponseEntry {
  const OneCallResponseEntry(this.dt, this.temp, this.pressure, this.humidity, this.clouds, this.windSpeed, this.title, this.description, this.icon);
  final int dt;
  final double temp;
  final int pressure;
  final int humidity;
  final int clouds;
  final double windSpeed;
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
    'title': title,
    'description': description,
    'icon': icon
  };

  static OneCallResponseEntry fromJson(final Map<String, dynamic> data) {
    final dt = data['dt'] as int;
    late double temp = 0.0;
    if (data['temp'] is Map<String, dynamic>) {
      temp = data['temp']['day'] as double;
    } else {
      temp = data['temp'] as double;
    }
    final pressure = data['pressure'] as int;
    final humidity = data['humidity'] as int;
    final clouds = data['clouds'] as int;
    final windSpeed = data['wind_speed'] as double;
    final weather = data['weather'] as List<dynamic>;
    final title = weather[0]['main'] as String;
    final description = weather[0]['description'] as String;
    final icon = weather[0]['icon'] as String;
    return OneCallResponseEntry(dt, temp, pressure, humidity, clouds, windSpeed, title, description, icon);
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