import 'package:flutter/material.dart';
import 'package:google_maps_app/screens/guest_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = '/signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController? _textController1;
  TextEditingController? _textController2;

  late bool _passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _textController1 = TextEditingController();
    _textController2 = TextEditingController();
    _passwordVisibility = false;
  }

  @override
  void dispose() {
    _textController1?.dispose();
    _textController2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final h = mediaQuery.height;

    return Scaffold(
      body: SafeArea(
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
                        controller: _textController1,
                        autofocus: true,
                        obscureText: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter an email.';
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
                        controller: _textController2,
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
              // submit button
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //  TODO: check validity at backend

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
                    onPressed: () {},
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
                  onPressed: () {
                    Navigator.of(context).pushNamed(GuestPage.routeName);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
    );
  }
}
