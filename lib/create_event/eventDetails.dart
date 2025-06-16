import 'package:evently_c14_online_sun/core/resources/colors_manager.dart';
import 'package:evently_c14_online_sun/core/routes_manager/routes_manager.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:evently_c14_online_sun/data/data_model/userDM.dart';
import 'package:evently_c14_online_sun/fbservices/fbservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/widgets/location_container.dart';

class Eventdetails extends StatelessWidget {
  const Eventdetails({super.key, required this.event});
  final EventDM event;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event details"),
        actions: event.userID==userDM.currentUser!.id?[
          IconButton(onPressed:(){ Navigator.pushNamed(context,RoutesManager.createEvent,arguments: event);}, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: ()async{    await fbservices.DeleteEvent(event).then((value){
              Navigator.pop(context);
            });
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ]:[]
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                event.category.imagePath!,
              ),
            ),
          ),
          const SizedBox(height: 11),
          Center(
            child: Text(
              event.title,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1.5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${event.dateTime.year}/",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                        Text("${event.dateTime.month}/",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                        Text(
                          "${event.dateTime.day}",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${event.dateTime.hour}:",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: theme.primaryColor),
                        ),
                        Text(
                          "${event.dateTime.minute}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: theme.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),

          LocationContainer(
            lat: event.lat!,
            lng: event.lng!,
          ),
          const SizedBox(height: 11),

          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primaryColor, width: 1.5),
              ),
              height: 208,
              child: GoogleMap(
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: false,
                markers: {
                  Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(event.lat!, event.lng!),
                  ) // Marker
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(event.lat!, event.lng!),
                    zoom: 13),
              )
          ),
          const SizedBox(height: 11),
          Text("Description",style: theme.textTheme.displayMedium?.copyWith(color: theme.primaryColor)),
          Text("${event.description}",style: theme.textTheme.bodyLarge?.copyWith(color: theme.primaryColor))

        ],
      ),
    );
  }

}
