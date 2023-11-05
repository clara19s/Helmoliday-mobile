import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helmoliday/view_model/holiday/holiday_map_view_model.dart';
import 'package:provider/provider.dart';

class HolidayMapScreen extends StatefulWidget {
  const HolidayMapScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<HolidayMapScreen> createState() => _HolidayMapScreenState();
}

class _HolidayMapScreenState extends State<HolidayMapScreen> {
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

  // Attends que Google Maps soit prêt
  // Fix temporaire de :
  // - https://github.com/flutter/flutter/issues/25298
  // - https://github.com/flutter/flutter/issues/29181
  // Source : https://github.com/flutter/flutter/issues/29181#issuecomment-620917105
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (nContext) => HolidayMapViewModel(context, widget.id),
      child: Consumer<HolidayMapViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Itinéraire'),
          ),
          body: FutureBuilder(
            future: viewModel.itineraryInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(snapshot.data!.boundsNe.latitude,
                        snapshot.data!.boundsNe.longitude),
                    zoom: 14.50,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                    waitForGoogleMap(controller).then((_) {
                      updateCameraPosition(
                        LatLng(snapshot.data!.boundsNe.latitude,
                            snapshot.data!.boundsNe.longitude),
                        LatLng(snapshot.data!.boundsSw.latitude,
                            snapshot.data!.boundsSw.longitude),
                      );
                    });
                  },
                  cameraTargetBounds: CameraTargetBounds(
                    LatLngBounds(
                      northeast: LatLng(snapshot.data!.boundsNe.latitude,
                          snapshot.data!.boundsNe.longitude),
                      southwest: LatLng(snapshot.data!.boundsSw.latitude,
                          snapshot.data!.boundsSw.longitude),
                    ),
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('origin'),
                      position: LatLng(snapshot.data!.startLocation.latitude,
                          snapshot.data!.startLocation.longitude),
                      infoWindow: const InfoWindow(title: 'Départ'),
                    ),
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: LatLng(snapshot.data!.endLocation.latitude,
                          snapshot.data!.endLocation.longitude),
                      infoWindow: const InfoWindow(title: 'Arrivée'),
                    ),
                  },
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId('route'),
                        color: Colors.blue,
                        width: 5,
                        points: snapshot.data!.polylineCoordinates
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList()),
                  },
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              viewModel.goToNavigation();
            },
            child: const Icon(Icons.navigation),
          ),
        ),
      ),
    );
  }
}
