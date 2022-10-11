import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../providers/user_provider.dart';

class EditDetailsScreen extends StatefulWidget {
  const EditDetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-details-screen';

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  TextEditingController? _emailController;
  TextEditingController? _currPasswordController;
  TextEditingController? _passwordController;
  TextEditingController? _password2Controller;
  TextEditingController? _nameController;
  TextEditingController? _addressController;
  String? _errorMessage = null;

  late bool _passwordVisibility = false;
  late bool _currPasswordVisibility = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _currPasswordKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _password2Key = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _currPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _password2Controller = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _passwordVisibility = false;
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _currPasswordController?.dispose();
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
                  // edit profile text
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Edit Profile',
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
                        // current password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: TextFormField(
                            key: _currPasswordKey,
                            controller: _currPasswordController,
                            autofocus: true,
                            obscureText: !_currPasswordVisibility,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a password.';
                              } else if (value.length < 6) {
                                return 'Password must be atleast 6 characters long.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (String? value) {
                              _currPasswordKey.currentState!.validate();
                            },
                            decoration: InputDecoration(
                              labelText: 'Current Password',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _currPasswordVisibility =
                                        !_currPasswordVisibility;
                                  });
                                },
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _currPasswordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF757575),
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // new password
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
                              labelText: 'New Password',
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
                              .editUser(
                            name: _nameController!.text,
                            emailAddress: _emailController!.text,
                            currPassword: _currPasswordController!.text,
                            newPassword: _password2Controller!.text,
                            address: _addressController!.text,
                          );
                          if (message != null) {
                            setState(() {
                              _errorMessage = message;
                            });
                          } else {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Text(
                        'Edit',
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
