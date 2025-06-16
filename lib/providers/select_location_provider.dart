import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationProvider extends ChangeNotifier {
  CameraPosition mylocation = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 15,
  );

  Set<Marker> Markers = {};

  late GoogleMapController controller;

  SelectLocationProvider() {
    Markers = {
      Marker(
        markerId: const MarkerId('myLocation'),
        position: mylocation.target,
        infoWindow: const InfoWindow(title: 'My Location'),
      ),
    };
  }

  goToMyLocation(LatLng location) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 15),
      ),
    );
  }

  LatLng? selectedLocation;

  changeSelectedLocation(LatLng location) {
    selectedLocation = location;

    Markers = {
      // My Location Marker
      Marker(
        markerId: const MarkerId('myLocation'),
        position: mylocation.target,
        infoWindow: const InfoWindow(title: 'My Location'),
      ),
      // Event Location Marker
      Marker(
        markerId: const MarkerId('eventLocation'),
        position: location,
        infoWindow: const InfoWindow(title: 'Event Location'),
      ),
    };

    goToMyLocation(location);
    notifyListeners();
  }
}
