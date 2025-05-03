import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenUtils {
  /// Returns height based on % of screen height
  static double height(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent;
  }

  /// Returns width based on % of screen width
  static double width(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent;
  }

  /// Get full screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get full screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> debugPrintSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final allPrefs = prefs.getKeys();

    for (String key in allPrefs) {
      final value = prefs.get(key);
      debugPrint('[$key] = $value');
    }
  }
}
