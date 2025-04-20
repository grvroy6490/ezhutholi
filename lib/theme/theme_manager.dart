import 'package:eluthozhi_v3/constants/color_scheme_data.dart';
import 'package:eluthozhi_v3/providers/button_style_provider.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static TextStyle displayLarge() => const TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.normal,
        fontFamily: 'NotoSans',
      );

  static TextStyle displayMedium() => const TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.normal,
        fontFamily: 'NotoSans',
      );

  static TextStyle displaySmall() => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.normal,
        fontFamily: 'NotoSans',
      );

  static TextStyle headlineLarge() => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSans',
      );

  static TextStyle headlineMedium() => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.normal,
        fontFamily: 'NotoSans',
      );

  static TextStyle headlineSmall() => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSans',
      );

  static TextStyle titleLarge() => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      );

  static TextStyle titleMedium() => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
      );

  static TextStyle titleSmall() => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      );

  static TextStyle labelLarge() => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
      );

  static TextStyle labelMedium() => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
      );

  static TextStyle labelSmall() => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
      );

  static TextStyle bodyLarge() => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
      );
}

class ButtonStyleManager {
  static ButtonStyle getButtonStyle({
    required ButtonStyleType type,
    required bool isDarkMode,
    required Color paletteColor,
  }) {
    final primary = isDarkMode ? const Color(0xFF181B2A) : Colors.white;

    switch (type) {
      case ButtonStyleType.defaultFilled:
        return ElevatedButton.styleFrom(
          backgroundColor: paletteColor,
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );

      case ButtonStyleType.neonGlow:
        return OutlinedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: paletteColor,
          side: BorderSide(color: paletteColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );

      case ButtonStyleType.subtle:
        return ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: paletteColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
    }
  }
}

/// Dynamic Theme Generator
ThemeData getTheme(bool isDark) {
  final scheme = isDark ? completeColorScheme.dark : completeColorScheme.light;

  return ThemeData(
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: hexToColor(scheme['Primary']['Main']),
      onPrimary: hexToColor(scheme['Primary']['On Main']),
      secondary: hexToColor(scheme['Secondary']['Main']),
      onSecondary: hexToColor(scheme['Secondary']['On Main']),
      background: hexToColor(scheme['Schemes']['Background']),
      onBackground: hexToColor(scheme['Schemes']['On Background']),
      surface: hexToColor(scheme['Schemes']['Surface']),
      onSurface: hexToColor(scheme['Schemes']['On Surface']),
      error: hexToColor(scheme['Error']['Main']),
      onError: hexToColor(scheme['Error']['On Main']),
    ),
  );
}


Color hexToColor(String hex, {double? alpha}) {
  hex = hex.replaceAll('#', '');

  if (hex.length == 6) {
    hex = 'FF$hex'; // full opacity
  } else if (hex.length == 8) {
    // Convert RGBA → ARGB
    hex = hex.substring(6, 8) + hex.substring(0, 6);
  } else {
    throw FormatException('Hex color must be 6 or 8 characters');
  }

  int colorInt = int.parse(hex, radix: 16);

  // Apply alpha override if provided
  if (alpha != null) {
    int alphaInt = (alpha * 255).round().clamp(0, 255);
    colorInt = (alphaInt << 24) | (colorInt & 0x00FFFFFF);
  }

  return Color(colorInt);
}




Color getFigmaColor(BuildContext context, String group, String key) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final scheme = isDark ? completeColorScheme.dark : completeColorScheme.light;

  final hex = scheme[group]?[key];
  if (hex is String) {
    return hexToColor(hex);
  }
  return Colors.transparent;
}
