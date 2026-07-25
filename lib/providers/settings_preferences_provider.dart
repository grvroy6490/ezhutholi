import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterStyle { colorChips, colorDots }

enum TypoStyle { styleDefault }

class SettingsPreferencesProvider with ChangeNotifier {
  FilterStyle _filterStyle = FilterStyle.colorChips;
  TypoStyle _typoStyle = TypoStyle.styleDefault;

  FilterStyle get filterStyle => _filterStyle;
  TypoStyle get typoStyle => _typoStyle;

  SettingsPreferencesProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final filterIndex = prefs.getInt('filterStyle') ?? 0;
    final typoIndex = prefs.getInt('typoStyle') ?? 0;
    _filterStyle = FilterStyle.values[
        filterIndex.clamp(0, FilterStyle.values.length - 1)];
    _typoStyle =
        TypoStyle.values[typoIndex.clamp(0, TypoStyle.values.length - 1)];
    notifyListeners();
  }

  Future<void> setFilterStyle(FilterStyle style) async {
    if (_filterStyle == style) return;
    _filterStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('filterStyle', style.index);
  }

  Future<void> setTypoStyle(TypoStyle style) async {
    if (_typoStyle == style) return;
    _typoStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('typoStyle', style.index);
  }
}
