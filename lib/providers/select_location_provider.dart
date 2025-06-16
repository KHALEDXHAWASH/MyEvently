import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationProvider extends ChangeNotifier
{
  CameraPosition mylocation=CameraPosition(

      target: LatLng(37.43296265331129, -122.08832357078792),
      zoom: 19.151926040649414);
  Set<Marker> Markers = {
    Marker(
      markerId: const MarkerId('1'),
      position: const LatLng(37.43296265531129, -122.08832357078792),
      infoWindow: const InfoWindow(title: 'hello'),
    ),
  };
  Set<Circle> Circles = {
    Circle(
      circleId: const CircleId('11'),
      center: const LatLng(37.43296265331129, -122.08832357078792),
      radius: 100,
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.7),
    ),
  };
  late GoogleMapController controller ;
  goToMyLocation(LatLng location)
  {
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target:LatLng(location.latitude,location.longitude),zoom: 19.151926040649414)
        )
    );
    Markers = {
      Marker(
        markerId:  MarkerId('1'),
        position:  LatLng(location.latitude, location.longitude),
        infoWindow:  InfoWindow(title: 'hello'),
      ),

    };
  }
  LatLng ? selectedLocation;
  changeSelectedLocation(LatLng location) {
    selectedLocation = location;
    goToMyLocation(location);
    notifyListeners();
  }

}
