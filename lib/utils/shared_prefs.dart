import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static SharedPreferences? prefs;

  static Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
