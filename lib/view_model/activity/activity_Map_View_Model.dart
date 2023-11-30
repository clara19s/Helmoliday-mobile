import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/activity.dart';
import 'package:helmoliday/model/lat_lng.dart' as helmo;

import '../../repository/activity_repository.dart';
import '../../service/location_service.dart';


class ActivityMapViewModel extends ChangeNotifier {
  late final ActivityRepository _activityRepository;
  late final LocationService _locationService;
  final BuildContext context;
  final String id;
  late Activity activity;
  late Future<ItineraryInfo> itineraryInfo;

  ActivityMapViewModel(this.context, this.id) {
    _activityRepository = context.read<ActivityRepository>();
    _locationService = context.read<LocationService>();
    itineraryInfo = fetchItineraryInfo();
  }

  Future<Activity> _getActivity(String id) async {
    return _activityRepository.getDetailActivity(id);
  }

  Future<ItineraryInfo> fetchItineraryInfo() async {
    activity = await _getActivity(id);
    final origin = await _locationService.getCurrentLocation();
    if (origin == null) {
      throw LocationServiceException('Cannot get current location');
    }
    final destination = activity.address.toString();
    final directions = await _locationService.getDirections(
        origin.toString(), destination);
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
        'google.navigation:q=${Uri.encodeFull(activity.address.toString())}'));
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
