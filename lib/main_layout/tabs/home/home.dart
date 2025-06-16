import 'package:evently_c14_online_sun/core/resources/constant_manager.dart';
import 'package:evently_c14_online_sun/core/routes_manager/routes_manager.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_event_widget.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_tab_bar.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:evently_c14_online_sun/data/data_model/userDM.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../fbservices/fbservices.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedTabIndex = 0;
  CategoryDM selectedCategory = ConstantManager.categories[0];

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: REdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(16.r))),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcome_back,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  userDM.currentUser!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Text(
                      "Cairo, Egypt",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                CustomTabBar(
                    onCategoryTabClicked: (category) {
                      selectedCategory = category;
                   //   print(selectedCategory.id);
                      setState(() {});
                    },
                    categories: ConstantManager.categories,
                    selectedTabBg: Theme.of(context).colorScheme.secondary,
                    unselectedTabBg: Colors.transparent,
                    selectedLabelColor: Theme.of(context).colorScheme.onSecondary,
                    unSelectedLabelColor:
                    Theme.of(context).colorScheme.secondaryContainer)
              ],
            ),
          ),
        ),

        StreamBuilder(
          stream: fbservices.getEventsRealTimeUpdates(selectedCategory),
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
                  itemBuilder: (context, index) => InkWell(
                    onTap: (){Navigator.pushNamed(context,RoutesManager.eventsDetails,arguments: events[index]
                    );
                    },

                    child: CustomEventWidget(
                      event: events[index],
                      markAsFav: userDM.currentUser!.favouriteEventsIds
                          .contains(events[index].id),
                    ),
                  ),
                  itemCount: events.length,
                ));
          },
        )
      ],
    );
  }

}

/// i18n