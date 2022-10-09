import 'package:flutter/widgets.dart';
import 'package:google_maps_app/screens/guest_page.dart';
import '../screens/signin_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // signin screen
  SignInScreen.routeName: (BuildContext ctx) => const SignInScreen(),
  // guest page
  GuestPage.routeName: (BuildContext ctx) => const GuestPage(),
};
