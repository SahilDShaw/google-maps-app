import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../tabs/location_tab.dart';
import '../tabs/profile_tab.dart';
import '../theme/config.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          elevation: 5,
          actions: [
            // theme switch button
            IconButton(
              onPressed: () {
                currentTheme.switchTheme();
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
                await Provider.of<UserProvider>(context, listen: false)
                    .signOutUser();
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
              Tab(
                icon: Icon(Icons.location_on),
                text: 'Location',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileTab(),
            LocationTab(),
          ],
        ),
      ),
    );
  }
}
