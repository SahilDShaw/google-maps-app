import 'package:flutter/widgets.dart';

import '../screens/edit_details_screen.dart';
import '../screens/guest_page.dart';
import '../screens/home_screen.dart';
import '../tabs/location_tab.dart';
import '../tabs/profile_tab.dart';
import '../screens/signup_screen.dart';
import '../screens/signin_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // signin screen
  SignInScreen.routeName: (BuildContext ctx) => const SignInScreen(),
  // guest page
  GuestPage.routeName: (BuildContext ctx) => const GuestPage(),
  // home screen
  HomeScreen.routeName: (BuildContext ctx) => HomeScreen(),
  // profile screen
  ProfileTab.routeName: (BuildContext ctx) => const ProfileTab(),
  // location screen
  LocationTab.routeName: (BuildContext ctx) => const LocationTab(),
  // signup screen
  SignUpScreen.routeName: (BuildContext ctx) => const SignUpScreen(),
  // edit details screen
  EditDetailsScreen.routeName: (BuildContext ctx) => const EditDetailsScreen(),
};
