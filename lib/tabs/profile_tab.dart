import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_app/screens/edit_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final name = provider.name;
    final email = provider.email;
    final address = provider.address;

    Widget listTileBuilder(String field, String value) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              field,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              value,
              softWrap: true,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Personal Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditDetailsScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                      padding: const EdgeInsets.all(15),
                    ),
                  ],
                ),
              ),
              listTileBuilder('Name', name.toString()),
              listTileBuilder('Email', email.toString()),
              listTileBuilder('Address', address.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
