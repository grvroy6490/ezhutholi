import 'package:flutter/material.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';

class ButtonPalette {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const ButtonPalette({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

class ThemedButtonPalettes {
  static List<ButtonPalette> _lightPalettes = _generatePalettes(false);
  static List<ButtonPalette> _darkPalettes = _generatePalettes(true);
  static const List<String> paletteNames = [
    'default',
    'RedTheme',
    'BlueTheme',
  ];

  static List<ButtonPalette> _generatePalettes(bool isDarkMode) {
    return [
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Green', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Green', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Green', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorDirect(isDarkMode, 'Secondary', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorDirect(isDarkMode, 'Secondary', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorDirect(isDarkMode, 'Secondary', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Pink', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Pink', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Pink', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Yellow', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Yellow', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Yellow', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Orange', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Orange', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Orange', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Magenda', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Magenda', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Magenda', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Brown', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Brown', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Brown', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Blue Grey', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Blue Grey', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Blue Grey', isDarkMode ? 'Main' : 'Light'),
      ),
      ButtonPalette(
        backgroundColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Tourkish', isDarkMode ? 'Light' : 'Main'),
        borderColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Tourkish', isDarkMode ? 'Light' : 'Main'),
        textColor: getFigmaColorThreeLevelDirect(isDarkMode, 'Supporting', 'Tourkish', isDarkMode ? 'Main' : 'Light'),
      ),
    ];
  }

  static void refreshPalettes(bool isDarkMode) {
    _lightPalettes = _generatePalettes(false);
    _darkPalettes = _generatePalettes(true);
    debugPrint("Button palettes refreshed for ${isDarkMode ? "Dark" : "Light"} Mode");
  }

  static ButtonPalette getMainPalette({
    required String themeName,
    required int categoryIndex,
    required bool isDarkMode,
  }) {
    final list = isDarkMode ? _darkPalettes : _lightPalettes;
    return list[categoryIndex % list.length];
  }

  static ButtonPalette getSubPalette({
    required String themeName,
    required int mainCategoryIndex,
    required int subCategoryIndex,
    required bool isDarkMode,
  }) {
    final list = isDarkMode ? _darkPalettes : _lightPalettes;
    final base = mainCategoryIndex % list.length;
    final alternate = (mainCategoryIndex + 1) % list.length;
    return (subCategoryIndex.isEven) ? list[base] : list[alternate];
  }
}
