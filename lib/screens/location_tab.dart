import 'package:flutter/material.dart';

class LocationTab extends StatelessWidget {
  const LocationTab({Key? key}) : super(key: key);

  static const routeName = '/location-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Location Screen'),
        ),
      ),
    );
  }
}
