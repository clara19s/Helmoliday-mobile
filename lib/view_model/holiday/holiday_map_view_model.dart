import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helmoliday/service/location_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/holiday.dart';
import '../../repository/holiday_repository.dart';

class HolidayMapViewModel extends ChangeNotifier {
  late final HolidayRepository _holidayRepository;
  late final LocationService _locationService;
  final BuildContext context;
  final String id;
  late Holiday holiday;
  late Future<List<LatLng>> polylineCoordinates;

  HolidayMapViewModel(this.context, this.id) {
    _holidayRepository = context.read<HolidayRepository>();
    _locationService = context.read<LocationService>();
    polylineCoordinates = init();
  }

  Future<Holiday> _getHoliday(String id) async {
    return _holidayRepository.getHoliday(id);
  }

  Future<List<LatLng>> init() async {
    holiday = await _getHoliday(id);
    var currentLocation = await _locationService.getCurrentLocation();
    var destinationLocation =
        await _locationService.getLocationFromQuery(holiday.address.toString());
    if (currentLocation != null && destinationLocation != null) {
      var polylines = await _locationService.getPolylinePoints(
          currentLocation, destinationLocation);
      if (polylines != null) {
        List<LatLng> polylineCoordinates = [];
        for (var polyline in polylines) {
          polylineCoordinates
              .add(LatLng(polyline.latitude, polyline.longitude));
        }
        return polylineCoordinates;
      }
    }
    return [];
  }

  Future<void> goToNavigation() async {
    await launchUrl(Uri.parse(
        'google.navigation:q=${Uri.encodeFull(holiday.address.toString())}'));
    return Future.value();
  }
}
