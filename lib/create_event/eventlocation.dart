import 'package:evently_c14_online_sun/core/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/select_location_provider.dart';

class SelectedLocation extends StatelessWidget {
  const SelectedLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SelectLocationProvider(),
      child: Consumer<SelectLocationProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body:Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      onMapCreated :(controller)
                    {
                      provider.controller=controller;

                      },
                      onTap: (LatLng l){
                        provider.changeSelectedLocation(l);
                        Navigator.pop(context,provider.selectedLocation);
                      },
                      markers: provider.Markers,
                        initialCameraPosition: provider.mylocation,
                        ),

                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.h),
                    color: Theme.of(context).primaryColor,
                    child:
                    Text("Select this location",style: Theme.of(context).textTheme.labelMedium?.copyWith(color: ColorsManager.white)
                    ),
                  )
                ],
              ),

            
          );
        },
      ),
    );
  }
}
