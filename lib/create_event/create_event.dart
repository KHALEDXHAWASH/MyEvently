import 'package:evently_c14_online_sun/core/resources/assets_manager.dart';
import 'package:evently_c14_online_sun/core/resources/colors_manager.dart';
import 'package:evently_c14_online_sun/core/resources/constant_manager.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_elevated_button.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_text_form_field.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_tab_bar.dart';
import 'package:evently_c14_online_sun/core/widgets/event_appointment_widget.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/data_model/categoryDM.dart';
import '../fbservices/fbservices.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

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
    // TODO: implement initState
    super.initState();
    titlecontroller = TextEditingController();
    descontroller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titlecontroller.dispose();
    descontroller.dispose();
  }

  CategoryDM selectedCategory = ConstantManager.categoriesWithoutAll[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.create_event,
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
                  oncategorytabclick: oncategoryclick,
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
                    onPress:_showEventTime,
                    icon: Icons.access_time_rounded,
                    appointmentTitle:
                        "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
                    buttonTitle: AppLocalizations.of(context)!.choose_time),
                CustomElevatedButton(
                    title: AppLocalizations.of(context)!.add_event,
                    onPress: _createevent)
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
    if (!(formKey.currentState!.validate()))
    {
      return;
    }
    try {
      EventDM event = EventDM(
        category: selectedCategory,
        title: titlecontroller.text,
        description: descontroller.text,
        dateTime: selectedDate.copyWith(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
        ),
      );
      await fbservices.addEventToFireStore(event);
      Navigator.pop(context);
    } catch (exception) {
      print(exception.toString());
    }
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
