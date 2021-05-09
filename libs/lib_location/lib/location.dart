
// ignore: import_of_legacy_library_into_null_safe
import 'package:location/location.dart';

class LocationInfo {
  const LocationInfo(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  String toString() => toJson().toString();
}

enum LocationPermissionStatus {
  deniedForever,
  denied,
  granted,
  grantedLimited,
}

class LocationPermissionStatusHelper {
  static bool isDenied(final LocationPermissionStatus status) => status == LocationPermissionStatus.denied || status == LocationPermissionStatus.deniedForever;
  static bool isDeniedForever(final LocationPermissionStatus status) => status == LocationPermissionStatus.deniedForever;
  static bool isGranted(final LocationPermissionStatus status) => status == LocationPermissionStatus.granted || status == LocationPermissionStatus.grantedLimited;
}

class LocationManager {

  static Location get _location => Location();

  static LocationPermissionStatus _fromPermissionStatus(final PermissionStatus status) {
    switch(status) {
      case PermissionStatus.denied:
        return LocationPermissionStatus.denied;
      case PermissionStatus.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      case PermissionStatus.grantedLimited:
        return LocationPermissionStatus.grantedLimited;
      default:
        return LocationPermissionStatus.denied;
    }
  }

  static Future<LocationPermissionStatus> _locationPermissionStatus() async {
    return _fromPermissionStatus( await _location.hasPermission());
  }

  static Future<LocationPermissionStatus> requestLocationPermission() async {
    var status = await _locationPermissionStatus();
    if (LocationPermissionStatusHelper.isDeniedForever(status)) {
      return status;

    } else if (LocationPermissionStatusHelper.isDenied(status)) {
      try {
        status = _fromPermissionStatus(await _location.requestPermission());
      } catch (_) {}
    }
    return status;
  }

  static Future<bool> requestLocationToggleOn() async {
    var gpsEnabled = await _location.serviceEnabled();
    if (!gpsEnabled) {
      try {
        gpsEnabled = await _location.requestService();
      } catch(_) {}
    }
    return gpsEnabled;
  }

  static Future<LocationInfo?> requestCurrentLocation() async {
    try {
      print('1');
      final locationData = await _location.getLocation();
      print('3');
      return LocationInfo(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } catch (e) {
      return null;
    }
  }
}