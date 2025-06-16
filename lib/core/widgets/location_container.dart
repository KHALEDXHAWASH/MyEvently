import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationContainer extends StatefulWidget
{
  const LocationContainer({super.key, required this.lat, required this.lng});
  final double lat,lng;

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  @override
  void initState() {
    _converttoaddress();
    // TODO: implement initState
    super.initState();
  }
  String address="event address";
  _converttoaddress() async{
    GeoCode geoCode = GeoCode();

    var response = await geoCode.reverseGeocoding(
        latitude: widget.lat, longitude: widget.lng);

    setState(() {
      address = '${response.countryName}, ${response.city}';
    });

  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
        Border.all(color: theme.primaryColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: theme.primaryColor, width: 1.5),
              color: theme.primaryColor,
            ),
            child: const Icon(
              Icons.gps_fixed,
              color: Colors.white,
            ),
          ),
          SizedBox(width:8.w),
          Text(address),

        ],
      ),
    );
  }
}


