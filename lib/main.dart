import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import './routes/routes.dart';
import './screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps App',
      themeMode: ThemeMode.light,
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}
