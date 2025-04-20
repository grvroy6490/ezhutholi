import 'package:flutter/material.dart';

class ColorSchemeModel {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;

  ColorSchemeModel({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
  });

  factory ColorSchemeModel.fromJson(Map<String, dynamic> json, bool isDark) {
    final mode = isDark ? json['modes']['Dark'] : json['modes']['Light'];

    return ColorSchemeModel(
      primary: _hexToColor(mode['Primary']['Main']['\$value'] ?? mode['Primary']['Main']),
      onPrimary: _hexToColor(mode['Primary']['On Main']['\$value'] ?? mode['Primary']['On Main']),
      secondary: _hexToColor(mode['Secondary']['Main']['\$value'] ?? mode['Secondary']['Main']),
      onSecondary: _hexToColor(mode['Secondary']['On Main']['\$value'] ?? mode['Secondary']['On Main']),
      background: _hexToColor(mode['Schemes']['Background']['\$value']),
      onBackground: _hexToColor(mode['Schemes']['On Background']['\$value']),
      surface: _hexToColor(mode['Schemes']['Surface']['\$value']),
      onSurface: _hexToColor(mode['Schemes']['On Surface']['\$value']),
      error: _hexToColor(mode['Error']['Main']['\$value']),
      onError: _hexToColor(mode['Error']['On Main']['\$value']),
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
