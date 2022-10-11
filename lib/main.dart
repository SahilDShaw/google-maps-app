import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../theme/config.dart';
import './providers/user_provider.dart';
import './routes/routes.dart';
import './screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print('Theme Changed!!');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (BuildContext ctx) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Google Maps App',
        themeMode: currentTheme.currentTheme(),
        theme: NordTheme.light(),
        darkTheme: NordTheme.dark(),
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
        routes: routes,
      ),
    );
  }
}
