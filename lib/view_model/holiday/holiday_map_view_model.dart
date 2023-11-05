import 'package:flutter/material.dart';
import 'package:helmoliday/service/location_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/holiday.dart';
import '../../repository/holiday_repository.dart';
import 'package:helmoliday/model/lat_lng.dart' as helmo;

class HolidayMapViewModel extends ChangeNotifier {
  late final HolidayRepository _holidayRepository;
  late final LocationService _locationService;
  final BuildContext context;
  final String id;
  late Holiday holiday;
  late Future<ItineraryInfo> itineraryInfo;

  HolidayMapViewModel(this.context, this.id) {
    _holidayRepository = context.read<HolidayRepository>();
    _locationService = context.read<LocationService>();
    itineraryInfo = fetchItineraryInfo();
  }

  Future<Holiday> _getHoliday(String id) async {
    return _holidayRepository.getHoliday(id);
  }

  Future<ItineraryInfo> fetchItineraryInfo() async {
    holiday = await _getHoliday(id);
    final origin = await _locationService.getCurrentLocation();
    if (origin == null) {
      throw LocationServiceException('Cannot get current location');
    }
    final destination = holiday.address.toString();
    final directions = await _locationService.getDirections(origin.toString(), destination);
    return ItineraryInfo(
      boundsNe: directions['bounds_ne'],
      boundsSw: directions['bounds_sw'],
      startLocation: directions['start_location'],
      endLocation: directions['end_location'],
      duration: directions['duration'],
      distance: directions['distance'],
      polylineCoordinates: directions['polyline'],
    );
  }

  Future<void> goToNavigation() async {
    await launchUrl(Uri.parse(
        'google.navigation:q=${Uri.encodeFull(holiday.address.toString())}'));
    return Future.value();
  }
}

class ItineraryInfo {
  helmo.LatLng boundsNe;
  helmo.LatLng boundsSw;
  helmo.LatLng startLocation;
  helmo.LatLng endLocation;
  Duration duration;
  String distance;
  List<helmo.LatLng> polylineCoordinates;

  ItineraryInfo({
    required this.boundsNe,
    required this.boundsSw,
    required this.startLocation,
    required this.endLocation,
    required this.duration,
    required this.distance,
    required this.polylineCoordinates,
  });
}
