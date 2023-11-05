import '../model/lat_lng.dart';

abstract class LocationService {
  Future<LatLng?> getCurrentLocation();

  Future<LatLng?> getLocationFromQuery(String query);

  Future<Map<String, dynamic>> getDirections(String origin, String destination);
}

enum LocationServiceStatus {
  unknown,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  permissionGranted,
}

class LocationServiceException implements Exception {
  final String message;

  LocationServiceException(this.message);
}