import 'package:flutter/material.dart';

/// PANTHER design tokens — color layer.
///
/// Two closed palettes (light/dark), not inverted from one another: dark is
/// the primary brand mode (matches the logo's black-glass-and-electric-blue
/// identity), light is a deliberately separate, airy counterpart.
class AppPalette {
  const AppPalette({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.overlay,
    required this.glow,
  });

  final Brightness brightness;

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color accent;

  final Color background;
  final Color surface;
  final Color surfaceElevated;

  final Color border;
  final Color borderStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  final Color overlay;
  final Color glow;

  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFFF8FAFF),
    secondary: Color(0xFF7FB4FF),
    onSecondary: Color(0xFF05070C),
    accent: Color(0xFF5EA1FF),
    background: Color(0xFF05070C),
    surface: Color(0xFF0B0F17),
    surfaceElevated: Color(0xFF121826),
    border: Color(0x1AFFFFFF),
    borderStrong: Color(0x33FFFFFF),
    textPrimary: Color(0xFFF4F6FB),
    textSecondary: Color(0xFFA6ADBB),
    textTertiary: Color(0xFF6B7280),
    success: Color(0xFF34D399),
    warning: Color(0xFFF6C453),
    error: Color(0xFFF06B6B),
    info: Color(0xFF5EA1FF),
    overlay: Color(0x99000000),
    glow: Color(0x663B82F6),
  );

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF3B82F6),
    onSecondary: Color(0xFFFFFFFF),
    accent: Color(0xFF2563EB),
    background: Color(0xFFF7F8FB),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    border: Color(0x14000000),
    borderStrong: Color(0x24000000),
    textPrimary: Color(0xFF15171F),
    textSecondary: Color(0xFF585F6E),
    textTertiary: Color(0xFF8A90A0),
    success: Color(0xFF12946B),
    warning: Color(0xFFB4790A),
    error: Color(0xFFD9433C),
    info: Color(0xFF2563EB),
    overlay: Color(0x66000000),
    glow: Color(0x332563EB),
  );
}
