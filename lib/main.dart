import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
//import 'package:omni_manager/constants/style.dart';
import 'package:omni_manager/pages/home.dart';
import 'package:omni_manager/pages/login.dart';
import 'package:omni_manager/pages/manager_validation.dart';
import 'package:omni_manager/pages/register.dart';
import 'package:omni_manager/pages/settings/settings.dart';
import 'package:omni_manager/pages/forms/forms.dart';
import 'utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Constants.getPrefs();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromRGBO(255, 36, 49, 1),
        alignment: Alignment.bottomCenter,
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromRGBO(34, 36, 49, 1),
        alignment: Alignment.bottomCenter,
      );
    }

    return MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.tab): ActivateIntent(),
      },
      debugShowCheckedModeBanner: false,
      home: Constants.prefs!.getBool("loggedIn") == true
          ? HomePage()
          : LoginPage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
      ),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        SettingsPage.routeName: (context) => SettingsPage(),
        ValidationPage.routeName: (context) => ValidationPage(),
        FormsPage.routeName: (context) => FormsPage(),
      },
    );
  }
}
