import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/location_tab.dart';
import '../theme/config.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({Key? key}) : super(key: key);

  static const routeName = '/guest-page';

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged In as Guest'),
        elevation: 5,
        actions: [
          // theme switch button
          IconButton(
            onPressed: () {
              currentTheme.switchTheme();
              setState(() {});
            },
            icon: Icon(
              (currentTheme.currentTheme() == ThemeMode.light)
                  ? Icons.sunny
                  : Icons.nightlight,
            ),
          ),
          // logout button
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: LocationTab(),
      ),
    );
  }
}
