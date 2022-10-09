import 'package:flutter/widgets.dart';

import '../screens/guest_page.dart';
import '../screens/home_screen.dart';
import '../screens/location_tab.dart';
import '../screens/profile_tab.dart';
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
};
