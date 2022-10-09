import 'package:flutter/material.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({Key? key}) : super(key: key);

  static const routeName = '/guest-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Guest Page'),
        ),
      ),
    );
  }
}
