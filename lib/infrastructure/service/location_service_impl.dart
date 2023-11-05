import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helmoliday/model/lat_lng.dart';

import '../../service/location_service.dart';

class LocationServiceImpl implements LocationService {
  final Dio _dio = Dio();
  final String googleApiKey = "AIzaSyBxNqfMwgcI1mLNSV-o9qqsDwaygyaRJqk";

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
  Future<LatLng?> getCurrentLocation() async {
    final status = await _checkPermission();
    if (status != LocationServiceStatus.permissionGranted) {
      throw LocationServiceException('Permission not granted');
    }

    final position = await Geolocator.getCurrentPosition();
    return LatLng(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<LatLng?> getLocationFromQuery(String query) async {
    var response = await _dio.get(
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(query)}&key=$googleApiKey");
    var json = response.data;
    if (json["status"] == "OK") {
      var location = json["results"][0]["geometry"]["location"];
      return LatLng(latitude: location["lat"], longitude: location["lng"]);
    }
    return null;
  }

  @override
  Future<List<LatLng>?> getPolylinePoints(
      LatLng origin, LatLng destination) async {
    var polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates
            .add(LatLng(latitude: point.latitude, longitude: point.longitude));
      }
      return polylineCoordinates;
    }
    return null;
  }
}
