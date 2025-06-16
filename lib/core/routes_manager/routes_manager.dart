import 'package:evently_c14_online_sun/autentication/signIn/signIn.dart';
import 'package:evently_c14_online_sun/autentication/signUp/signUp.dart';
import 'package:evently_c14_online_sun/create_event/create_event.dart';
import 'package:evently_c14_online_sun/create_event/eventlocation.dart';
import 'package:evently_c14_online_sun/data/data_model/event_DM.dart';
import 'package:evently_c14_online_sun/main_layout/main_layout.dart';
import 'package:flutter/cupertino.dart';

import '../../create_event/eventDetails.dart';
import '../forget pass/forget_password.dart';

class RoutesManager {
  static const String signUp = "/signUp";
  static const String signIn = "/signIn";
  static const String mainLayout = "/mainLayout";
  static const String createEvent = "/createEvent";
  static const String selectLocation = "/selectLocation";
  static const String eventsDetails = "/eventsDetails";
  static const String forgetPassword = "/forgetPassword";

  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case signUp:
        return CupertinoPageRoute(
          builder: (context) => const SignUp(),
        );
      case signIn:
        return CupertinoPageRoute(
          builder: (context) => const SignIn(),
        );
      case mainLayout:
        return CupertinoPageRoute(
          builder: (context) => const MainLayout(),
        );
      case createEvent:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) =>
              CreateEvent(event : settings.arguments as EventDM?),
        );
      case selectLocation:
        return CupertinoPageRoute(
          builder: (context) => const SelectedLocation(),

        );
      case eventsDetails:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) =>  Eventdetails(event : settings.arguments as EventDM),

        );
      case forgetPassword:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) =>  const ResetPassword() ,

        );
    }
  }
}
