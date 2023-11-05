import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helmoliday/view_model/holiday/holiday_map_view_model.dart';
import 'package:provider/provider.dart';

class HolidayMapScreen extends StatefulWidget {
  const HolidayMapScreen({super.key, required this.id});

  final String id;

  @override
  State<HolidayMapScreen> createState() => _HolidayMapScreenState();
}

class _HolidayMapScreenState extends State<HolidayMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (nContext) => HolidayMapViewModel(context, widget.id),
        child: Consumer<HolidayMapViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Itinéraire'),
                  ),
                  body: FutureBuilder(
                      future: model.polylineCoordinates,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var polylineCoordinates =
                              snapshot.data as List<LatLng>;
                          return GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  polylineCoordinates.first.latitude,
                                  polylineCoordinates.first.longitude
                              ),
                              zoom: 14.50,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            cameraTargetBounds: CameraTargetBounds(
                              LatLngBounds(
                                southwest: LatLng(
                                    polylineCoordinates.last.latitude,
                                    polylineCoordinates.last.longitude),
                                northeast: LatLng(
                                    polylineCoordinates.first.latitude,
                                    polylineCoordinates.first.longitude),
                              ),
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('origin'),
                                position: LatLng(
                                    polylineCoordinates.first.latitude,
                                    polylineCoordinates.first.longitude),
                                infoWindow: const InfoWindow(title: 'Départ'),
                              ),
                              Marker(
                                markerId: const MarkerId('destination'),
                                position: LatLng(
                                    polylineCoordinates.last.latitude,
                                    polylineCoordinates.last.longitude),
                                infoWindow: const InfoWindow(
                                    title: 'Arrivée'),
                              ),
                            },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId('route'),
                                color: Colors.blue,
                                width: 5,
                                points: snapshot.data as List<LatLng>,
                              ),
                            },
                            mapToolbarEnabled: false,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      model.goToNavigation();
                    },
                    child: const Icon(Icons.navigation),
                  ),
                )));
  }
}
