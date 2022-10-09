import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './providers/user_provider.dart';
import './routes/routes.dart';
import './screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        themeMode: ThemeMode.light,
        theme: NordTheme.light(),
        darkTheme: NordTheme.dark(),
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
        routes: routes,
      ),
    );
  }
}
