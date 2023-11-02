import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool _hasPermission = false;
  LatLng _currPosition = const LatLng(50.5859, 5.8693);

  @override
  initState() {
    super.initState();
    setPermissions();
  }

  void setPermissions() async {
    if (await Permission.location.isGranted) {
      setState(() {
        _hasPermission = true;
      });
      _updateUserLocation();
      return;
    }
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
      return;
    }
    Map<Permission, PermissionStatus> statuses =
        await [Permission.location].request();
    if (statuses[Permission.location]?.isGranted ?? false) {
      setState(() {
        _hasPermission = true;
      });
      _updateUserLocation();
    } else {
      if (!context.mounted) return;
      context.pop();
    }
  }

  _updateUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currPosition = LatLng(position.latitude, position.longitude);
      });
      if (_controller.isCompleted) {
        GoogleMapController mapController = await _controller.future;
        mapController.moveCamera(CameraUpdate.newLatLng(_currPosition));
      }
    } catch (e) {
      print("Erreur lors de la récupération de la position : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: _hasPermission
          ? GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(50.5859, 5.8693),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
