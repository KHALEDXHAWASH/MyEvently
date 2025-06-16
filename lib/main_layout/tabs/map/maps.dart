import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';

import '../../../core/resources/constant_manager.dart';
import '../../../core/widgets/custom_event_widget.dart';
import '../../../core/widgets/events_map_list.dart';
import '../../../data/data_model/event_DM.dart';
import '../../../data/data_model/userDM.dart';
import '../../../fbservices/fbservices.dart';
import '../../../providers/config_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late ConfigProvider mainProvider;

  @override
  void initState() {
    mainProvider = Provider.of<ConfigProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<ConfigProvider>(context);
    return Consumer<ConfigProvider>(
      builder: (BuildContext context, ConfigProvider provider, Widget? child) {
        return Stack(children: [
          GoogleMap(
            zoomControlsEnabled: false,

              onMapCreated: (controller) {
                provider.controller = controller;
              },
              markers: provider.Markers,
              initialCameraPosition: provider.mylocation),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100.h,
              child: StreamBuilder<List<EventDM>>(
                stream: fbservices.getEventsRealTimeUpdates(CategoryDM(id: null, name: "All Events", icon: Icons.home)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  List<EventDM> events = snapshot.data ?? [];
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: SizedBox(
                          width: 250.w,
                          child: InkWell(onTap:()
                              {
                                provider.goToMyLocation(LatLng(events[index].lat??0, events[index].lng??0));

                              },child: EventsMapList(eventDM: events[index])),

                        ),
                      ),
                      itemCount: events.length,

                    ),
                  );

                },
              ),
            ),
          )
        ]);
      },
    );
  }
}