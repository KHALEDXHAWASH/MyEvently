import 'package:evently_c14_online_sun/core/resources/colors_manager.dart';
import 'package:evently_c14_online_sun/core/resources/constant_manager.dart';
import 'package:evently_c14_online_sun/core/routes_manager/routes_manager.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_elevated_button.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_text_form_field.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_tab_bar.dart';
import 'package:evently_c14_online_sun/core/widgets/event_appointment_widget.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:evently_c14_online_sun/data/data_model/userDM.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/data_model/categoryDM.dart';
import '../fbservices/fbservices.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key, this.event});
  final EventDM? event;

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  late TextEditingController titlecontroller = TextEditingController();
  late TextEditingController descontroller = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String descriptioninputtrim(String input) {
    List<String> inputChars = input.split('');
    List<String> inputCharactersWithoutSpace = [];

    for (int i = 0; i < inputChars.length; i++) {
      if (inputChars[i].trim().isNotEmpty) {
        inputCharactersWithoutSpace.add(inputChars[i]);
      }
    }

    return inputCharactersWithoutSpace.join();
  }

  @override
  void initState() {
    super.initState();
    titlecontroller = TextEditingController();
    descontroller = TextEditingController();
    _initEditData();
  }

  void _initEditData() {
    if (widget.event != null) {
      titlecontroller.text = widget.event!.title;
      descontroller.text = widget.event!.description;
      selectedCategory = widget.event!.category;
      selectedDate = widget.event!.dateTime;
      selectedTime = TimeOfDay(
          hour: widget.event!.dateTime.hour,
          minute: widget.event!.dateTime.minute);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titlecontroller.dispose();
    descontroller.dispose();
  }

  CategoryDM selectedCategory = ConstantManager.categoriesWithoutAll[0];
  LatLng? location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event==null? "create event":"Edit details"

        ),
      ),
      body: Padding(
        padding: REdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(18.r),
                    child: Image.asset(selectedCategory.imagePath!)),
                CustomTabBar(
                  index: ConstantManager.categories.indexOf(selectedCategory),
                  onCategoryTabClicked: oncategoryclick,
                  categories: ConstantManager.categoriesWithoutAll,
                  selectedTabBg: ColorsManager.blue,
                  unselectedTabBg: Colors.transparent,
                  selectedLabelColor: ColorsManager.light,
                  unSelectedLabelColor: ColorsManager.blue,
                ),
                Text(
                  AppLocalizations.of(context)!.title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                CustomTextFormField(
                  validation: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return "Please enter a valid title.";
                    }
                    return null;
                  },
                  controller: titlecontroller,
                  hint: AppLocalizations.of(context)!.event_title,
                  prefixIcon: Icons.edit_note_outlined,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  AppLocalizations.of(context)!.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                CustomTextFormField(
                  controller: descontroller,
                  validation: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return "Please enter a description.";
                    }
                    if (descriptioninputtrim(input).length < 6) {
                      return "Description must be at least 6 characters long.";
                    }
                    return null;
                  },
                  hint: AppLocalizations.of(context)!.event_description,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                ),
                EventAppointmentWidget(
                    onPress: selectdate,
                    icon: Icons.date_range,
                    appointmentTitle:
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    buttonTitle: AppLocalizations.of(context)!.choose_date),
                SizedBox(
                  height: 8.h,
                ),
                EventAppointmentWidget(
                    onPress: _showEventTime,
                    icon: Icons.access_time_rounded,
                    appointmentTitle:
                    "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
                    buttonTitle: AppLocalizations.of(context)!.choose_time),
                SizedBox(height: 14.h,),
                CustomElevatedButton(
                  title: location == null
                      ? "Select Location"
                      : "[${location?.latitude}, ${location?.longitude}]",
                  onPress: () {
                    Navigator.pushNamed(context, RoutesManager.selectLocation)
                        .then((value) {
                      if (value != null) {
                        location = value as LatLng;
                        setState(() {});
                      }
                    });
                  },
                ),
                SizedBox(height: 14.h,),

                CustomElevatedButton(
                    title:  widget.event==null?AppLocalizations.of(context)!.add_event:"Update event",
                    onPress:widget.event==null?_createevent:_UpdateEvent)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void oncategoryclick(CategoryDM category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _createevent() async {
    if (!(formKey.currentState!.validate())) {
      return;
    }
    try {
      EventDM event = EventDM(
          userID: userDM.currentUser!.id,
          category: selectedCategory,
          title: titlecontroller.text,
          description: descontroller.text,
          dateTime: selectedDate.copyWith(
            hour: selectedTime.hour,
            minute: selectedTime.minute,
          ),
          lat: location?.latitude,
          lng: location?.longitude);
      await fbservices.addEventToFireStore(event);
      Navigator.pop(context);
    } catch (exception) {
      print(exception.toString());
    }
  }
  void _UpdateEvent() async {
    EventDM event = EventDM(
      userID: userDM.currentUser!.id,
      id: widget.event!.id, // This is the key fix
      category: selectedCategory,
      title: titlecontroller.text,
      description: descontroller.text,
      dateTime: selectedDate.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      ),
      lat: location?.latitude,
      lng: location?.longitude,
    );

    await fbservices.updateEvent(event).then((value) {
      Navigator.pushNamed(context,RoutesManager.mainLayout);
    });
  }


  void selectdate() async {
    selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 999)),
        initialDate: DateTime.now()) ??
        selectedDate;
    setState(() {});
  }

  void _showEventTime() async {
    selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()) ??
            selectedTime;
    selectedDate = selectedDate.copyWith(
        hour: selectedTime.hour, minute: selectedTime.minute);
    setState(() {});
  }
}
