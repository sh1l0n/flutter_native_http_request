//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';

class CityInfo {
  const CityInfo(this.postalCode, this.locality, this.subAdministrativeArea, this.country, this.isoCountryCode, this.latitude, this.longitude);
  final String? postalCode;
  final String? locality;
  final String? subAdministrativeArea;
  final String? country;
  final String? isoCountryCode;
  final double latitude;
  final double longitude;

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
    'postalCode': postalCode,
    'locality': locality,
    'subAdministrativeArea': subAdministrativeArea,
    'country': country,
    'isoCountryCode': isoCountryCode,
    'latitude': latitude,
    'longitude': longitude,
  };
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

  static Future<CityInfo?> requestCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      return getCityFromCoordinates(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } catch (e) {
      return null;
    }
  }

  static Future<CityInfo> getCityFromCoordinates(final double lat, final double lon) async {
    final placemark = (await geocoding.placemarkFromCoordinates(lat, lon)).first;
    return CityInfo(
      placemark.postalCode, 
      placemark.locality, 
      placemark.subAdministrativeArea, 
      placemark.country, 
      placemark.isoCountryCode,
      lat,
      lon,
    );
  }

  static Future<CityInfo> getCityFromAddress(final String address) async {
    final location = (await geocoding.locationFromAddress(address)).first;
    return getCityFromCoordinates(location.latitude, location.longitude);
  }
}