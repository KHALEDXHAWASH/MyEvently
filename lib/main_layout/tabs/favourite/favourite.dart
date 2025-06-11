import 'package:evently_c14_online_sun/core/widgets/custom_event_widget.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:flutter/material.dart';
import '../../../fbservices/fbservices.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<EventDM> filteredEvents = [];
  List<EventDM> favEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getFavEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterFavEventsBySearchKey,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                  ? const Center(
                child: Text(
                  'No favorite events found.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CustomEventWidget(
                      event: filteredEvents[index],
                      markAsFav: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getFavEvents() async
  {
    favEvents = await fbservices.getFavEvents();
    filteredEvents = favEvents;
    isLoading = false;
    setState(() {});
  }

  void filterFavEventsBySearchKey(String searchKey)
  {
    if (searchKey.trim().isEmpty) {
      filteredEvents = favEvents;
    } else {
      filteredEvents = favEvents.where((event)
      {
        final query = searchKey.toLowerCase().trim();
        return event.title.toLowerCase().contains(query) ||
            event.description.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {});
  }
}
