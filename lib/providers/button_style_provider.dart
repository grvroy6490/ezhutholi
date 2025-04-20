import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum ButtonStyleType { defaultFilled, neonGlow, subtle }

class ButtonStyleProvider extends ChangeNotifier {
  ButtonStyleType _style = ButtonStyleType.defaultFilled;

  ButtonStyleType get style => _style;

  ButtonStyleProvider() {
    _loadStyleFromPrefs();
  }

  void updateStyle(ButtonStyleType newStyle) async {
    _style = newStyle;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('buttonStyleIndex', newStyle.index);
  }

  void _loadStyleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('buttonStyleIndex') ?? 0;
    _style = ButtonStyleType.values[index];
    notifyListeners();
  }
}