import 'package:evently_c14_online_sun/core/widgets/custom_event_widget.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/resources/colors_manager.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: REdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterFavEventsBySearchKey,
              style: textTheme.bodySmall,
              cursorColor: ColorsManager.blue,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchFavorites,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                  ? Center(
                child: Text(
                  AppLocalizations.of(context)!.noFavoritesFound,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
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

  void getFavEvents() async {
    favEvents = await fbservices.getFavEvents();
    filteredEvents = favEvents;
    isLoading = false;
    setState(() {});
  }

  void filterFavEventsBySearchKey(String searchKey) {
    if (searchKey.trim().isEmpty) {
      filteredEvents = favEvents;
    } else {
      final query = searchKey.toLowerCase().trim();
      filteredEvents = favEvents.where((event) {
        return event.title.toLowerCase().contains(query) ||
            event.description.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {});
  }
}
