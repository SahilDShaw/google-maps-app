import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../location/location.dart';
import '../providers/user_provider.dart';
import '../screens/guest_page.dart';
import '../screens/home_screen.dart';
import '../screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = '/signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  String? _errorMessage = null;

  late bool _passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  // asking permission for location
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // getting address from lat and lng
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(MyLocation.currentPosition!.latitude,
            MyLocation.currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        MyLocation.currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // getting current position and address
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => MyLocation.currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => MyLocation.currentPosition = position);
      _getAddressFromLatLng(MyLocation.currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisibility = false;
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final h = mediaQuery.height;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // sign in text
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Color(0xff4C566A),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro',
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // email
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        child: TextFormField(
                          key: _emailKey,
                          controller: _emailController,
                          autofocus: true,
                          obscureText: false,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter an email.';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Enter a valid email.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (String? val) {
                            _emailKey.currentState!.validate();
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      // password
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        child: TextFormField(
                          key: _passwordKey,
                          controller: _passwordController,
                          autofocus: true,
                          obscureText: !_passwordVisibility,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a password.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (String? value) {
                            _passwordKey.currentState!.validate();
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _passwordVisibility = !_passwordVisibility;
                                });
                              },
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _passwordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF757575),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      _errorMessage.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                // submit button
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? message = await Provider.of<UserProvider>(
                                context,
                                listen: false)
                            .signInUser(_emailController!.text,
                                _passwordController!.text);
                        if (message != null) {
                          setState(() {
                            _errorMessage = message;
                          });
                        } else {
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .getDataFromFirebase();
                          await _getCurrentPosition();
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName('/'));
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.routeName);
                        }
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                // sign up button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // skip button
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () async {
                      await _getCurrentPosition();
                      Navigator.of(context).pushNamed(GuestPage.routeName);
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        'SKIP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
