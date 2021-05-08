
// ignore: import_of_legacy_library_into_null_safe
import 'package:location/location.dart';

class LocationInfo {
  const LocationInfo(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

class LocationManager {

  Location get _location => Location();

  Future<bool> requestLocationPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      try {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted == PermissionStatus.granted || permissionGranted == PermissionStatus.grantedLimited) {
          return true;
        }
      } catch (e) {
        return false;
      }
    } else {
      permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        return false;
      } else {
        return true;
      }
    }

    return false;
  }

  Future<bool> requestLocationToggleOn() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      try {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      } catch(e) {
        return false;
      }
    }
    return true;
  }

  Future<LocationInfo?> requestCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      return LocationInfo(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } catch (e) {
      return null;
    }
  }
}