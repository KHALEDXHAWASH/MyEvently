import 'package:evently_c14_online_sun/core/resources/assets_manager.dart';
import 'package:evently_c14_online_sun/core/resources/constant_manager.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_event_widget.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_tab_bar.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:evently_c14_online_sun/fbservices/fbservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
 const  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CategoryDM selectedCategory = ConstantManager.categories[0];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: REdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(17.r)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcome_back,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "king vamp",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Text(
                      "Memphis, USA",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                CustomTabBar(
                  oncategorytabclick: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  categories: ConstantManager.categories,
                  selectedTabBg: Theme.of(context).colorScheme.secondary,
                  unselectedTabBg: Colors.transparent,
                  selectedLabelColor:
                  Theme.of(context).colorScheme.onSecondary,
                  unSelectedLabelColor:
                  Theme.of(context).colorScheme.secondaryContainer,
                ),
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
                  itemBuilder: (context, index) => CustomEventWidget(
                    event: events[index],

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
