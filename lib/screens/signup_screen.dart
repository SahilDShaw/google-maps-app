import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../location/location.dart';
import '../screens/home_screen.dart';
import '../providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/signup-screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _password2Controller;
  TextEditingController? _nameController;
  TextEditingController? _addressController;
  String? _errorMessage = null;

  late bool _passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _password2Key = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();

  // asking premission for location
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
    _password2Controller = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _passwordVisibility = false;
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    _password2Controller?.dispose();
    _nameController?.dispose();
    _addressController?.dispose();
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // sign up text
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Sign Up',
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
                        // name
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: TextFormField(
                            key: _nameKey,
                            controller: _nameController,
                            autofocus: true,
                            obscureText: false,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a name.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (String? val) {
                              _nameKey.currentState!.validate();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                        ),
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
                        // address
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: TextFormField(
                            key: _addressKey,
                            controller: _addressController,
                            autofocus: true,
                            obscureText: false,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter an address.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (String? val) {
                              _addressKey.currentState!.validate();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Address',
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
                              } else if (value.length < 6) {
                                return 'Password must be atleast 6 characters long.';
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
                        // confirm password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: TextFormField(
                            key: _password2Key,
                            controller: _password2Controller,
                            autofocus: true,
                            obscureText: true,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a password.';
                              } else if (value.length < 6) {
                                return 'Password must be atleast 6 characters long.';
                              } else if (_passwordController == null) {
                                return 'Enter password first.';
                              } else if (_passwordController!.text != value) {
                                return 'Passwords don\'t match.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (String? value) {
                              _password2Key.currentState!.validate();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
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
                              .createNewUser(
                            name: _nameController!.text,
                            emailAddress: _emailController!.text,
                            password: _password2Controller!.text,
                            address: _addressController!.text,
                          );
                          if (message != null) {
                            setState(() {
                              _errorMessage = message;
                            });
                          } else {
                            await _getCurrentPosition();
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName('/'));
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          }
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
