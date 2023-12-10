import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helmoliday/model/lat_lng.dart' as helmoliday;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../service/location_service.dart';

class LocationServiceImpl implements LocationService {
  final Dio _dio = Dio();
  final String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  Future<LocationServiceStatus> _checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationServiceStatus.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationServiceStatus.permissionDenied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationServiceStatus.permissionDenied;
    }

    return LocationServiceStatus.permissionGranted;
  }

  @override
  Future<helmoliday.LatLng?> getCurrentLocation() async {
    final status = await _checkPermission();
    if (status != LocationServiceStatus.permissionGranted) {
      throw LocationServiceException('Permission not granted');
    }

    final position = await Geolocator.getCurrentPosition();
    return helmoliday.LatLng(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<helmoliday.LatLng?> getLocationFromQuery(String query) async {
    var response = await _dio.get(
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(query)}&key=$googleApiKey");
    var json = response.data;
    if (json["status"] == "OK") {
      var location = json["results"][0]["geometry"]["location"];
      return helmoliday.LatLng(latitude: location["lat"], longitude: location["lng"]);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    var response = await _dio.get(
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$googleApiKey");
    var json = response.data;

    var results = {
      "bounds_ne": helmoliday.LatLng(
        latitude: json["routes"][0]["bounds"]["northeast"]["lat"],
        longitude: json["routes"][0]["bounds"]["northeast"]["lng"],
      ),
      "bounds_sw": helmoliday.LatLng(
        latitude: json["routes"][0]["bounds"]["southwest"]["lat"],
        longitude: json["routes"][0]["bounds"]["southwest"]["lng"],
      ),
      "distance": json["routes"][0]["legs"][0]["distance"]["text"],
      "duration": Duration(
        seconds: json["routes"][0]["legs"][0]["duration"]["value"],
      ),
      "start_location": helmoliday.LatLng(
        latitude: json["routes"][0]["legs"][0]["start_location"]["lat"],
        longitude: json["routes"][0]["legs"][0]["start_location"]["lng"],
      ),
      "end_location": helmoliday.LatLng(
        latitude: json["routes"][0]["legs"][0]["end_location"]["lat"],
        longitude: json["routes"][0]["legs"][0]["end_location"]["lng"],
      ),
      "polyline": PolylinePoints().decodePolyline(
          json["routes"][0]["overview_polyline"]["points"])
          .map((e) => helmoliday.LatLng(latitude: e.latitude, longitude: e.longitude)).toList(),
    };

    print(results);

    return results;
  }
}
