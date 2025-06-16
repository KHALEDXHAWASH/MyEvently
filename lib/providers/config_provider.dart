import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class ConfigProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.light;

  bool get isDark => currentTheme == ThemeMode.dark;

  String currentLang = "en";

  bool get isEnglish => currentLang == "en";

  void changeAppTheme(ThemeMode newTheme) {
    // light
    if (currentTheme == newTheme) return;
    currentTheme = newTheme;
    notifyListeners();
  }

  void changAppLang(String newLang) {
    if (currentLang == newLang) return;
    currentLang = newLang;
    notifyListeners();
  }



  Location location = Location();
  String locationMessage = 'check location';

  getLocation  ()async
  {
    bool isPermissionGranted =  await _checkPermission();
    if(!isPermissionGranted){
      locationMessage = 'check permission denied';
      notifyListeners();
      return;
    }
    bool isServiceEnabled= await _checkServiceEnabled();
    if(!isServiceEnabled)
    {
      locationMessage = 'check service locator was denied';
            notifyListeners();
      return;
    }
    var myLocation=await location.getLocation();
    goToMyLocation(LatLng(myLocation.latitude??0,myLocation.longitude??0));
    notifyListeners();

  }
  Future<bool> _checkPermission()async
  {
  PermissionStatus ps = await location.hasPermission();
  if(ps == PermissionStatus.denied)
  {
    ps = await location.requestPermission();
  }
  bool checker =ps == PermissionStatus.granted;
    return checker;
  }
  Future<bool> _checkServiceEnabled() async {
    bool isServiceEnabled = await location.serviceEnabled();

    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
    }

    return isServiceEnabled;
  }
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
  void StreamLocation() {
    location.onLocationChanged.listen((LocationData locationData) {
      LatLng newPosition = LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);

      goToMyLocation(newPosition);

      notifyListeners();
    }
    );
  }




}
