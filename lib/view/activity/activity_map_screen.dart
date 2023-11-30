
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';

class ActivityMapScreen extends StatefulWidget {
  const ActivityMapScreen ({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  _ActivityMapScreenState createState() => _ActivityMapScreenState();
}

class _ActivityMapScreenState extends State<ActivityMapScreen> {

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

  Future<void> updateCameraPosition(
    LatLng ne,
    LatLng sw,
  ) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(northeast: ne, southwest: sw), 75),
    );
  }

  Future<void> waitForGoogleMap(GoogleMapController c) {
    return c.getVisibleRegion().then((value) {
      if (value.southwest.latitude != 0) {
        return Future.value();
      }

      return Future.delayed(const Duration(milliseconds: 100))
      .then((_) => waitForGoogleMap(c));
    });
  }

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
     create: (nContext) => ActivityMapViewModel(context, widget.id),
      ),
  }
}

