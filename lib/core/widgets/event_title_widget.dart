import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../fbservices/fbservices.dart';

class EventTitleWidget extends StatefulWidget {
  const EventTitleWidget(
      {super.key, required this.event, required this.markAsFav});

  final EventDM event;
  final bool markAsFav;

  @override
  State<EventTitleWidget> createState() => _EventTitleWidgetState();
}

class _EventTitleWidgetState extends State<EventTitleWidget> {
  late bool isFavouriteEvent = widget.markAsFav;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: REdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
                  widget.event.title,
                  style: Theme.of(context).textTheme.bodySmall,
                )),
            IconButton(
                onPressed: _markEventAsFav,
                icon: Icon(isFavouriteEvent
                    ? Icons.favorite
                    : Icons.favorite_border_outlined))
          ],
        ),
      ),
    );
  }

  void _markEventAsFav() async {
    isFavouriteEvent = !isFavouriteEvent;
    if (isFavouriteEvent) {
      await fbservices.addEventToFav(widget.event.id);
    } else {
      await fbservices.removeEventFromFav(widget.event.id);
    }
    setState(() {});
  }
}