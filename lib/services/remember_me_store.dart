import 'package:shared_preferences/shared_preferences.dart';

class RememberMeStore {
  static const _rememberKey = 'rememberMe';
  static const _emailKey = 'rememberedEmail';

  static Future<({bool rememberMe, String email})> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      rememberMe: prefs.getBool(_rememberKey) ?? false,
      email: prefs.getString(_emailKey) ?? '',
    );
  }

  static Future<void> save({
    required bool rememberMe,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, rememberMe);
    if (rememberMe) {
      await prefs.setString(_emailKey, email.trim());
    } else {
      await prefs.remove(_emailKey);
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberKey);
    await prefs.remove(_emailKey);
  }
}
