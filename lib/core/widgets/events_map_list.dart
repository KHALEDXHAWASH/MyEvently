import 'package:evently_c14_online_sun/core/resources/colors_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/data_model/event_DM.dart';

class EventsMapList extends StatelessWidget {
  const EventsMapList({super.key, required this.eventDM});

  final EventDM eventDM;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(13.w),
      width: size.width * 0.7,

      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorsManager.blue, width: 2.w),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),

              child: Image.asset(

                height: double.infinity,
                width: double.infinity,
                eventDM.category.imagePath!,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    eventDM.description,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    "${eventDM.lat} ${eventDM.lng}",

                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
