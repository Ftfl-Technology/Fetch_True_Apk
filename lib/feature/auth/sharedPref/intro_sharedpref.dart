import 'package:shared_preferences/shared_preferences.dart';

class IntroSharedpref {
  static const String introSeenKey = 'intro_seen';

  static Future<void> setIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(introSeenKey, true);
  }

  static Future<bool> isIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(introSeenKey) ?? false;
  }

  static Future<void> clearIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(introSeenKey);
  }
}
