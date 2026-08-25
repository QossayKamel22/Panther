import 'package:flutter/material.dart';

/// PANTHER design tokens — color layer.
///
/// Two closed palettes (light/dark), not inverted from one another: dark is
/// the primary brand mode (matches the logo's black-glass-and-electric-blue
/// identity), light is a deliberately separate, airy counterpart.
///
/// The mark itself is monochrome metal (white glyph / black glyph, no
/// baked-in color — see PantherMark), so the palette carries the brand
/// color: one deliberate cobalt accent against graphite/steel neutrals,
/// rather than two competing blues. `secondary` is a cool steel-slate — it
/// reads as "brushed metal" next to the mark instead of a second, redundant
/// blue.
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
    primary: Color(0xFF3563E9),
    onPrimary: Color(0xFFF8FAFF),
    secondary: Color(0xFF9AA7C7),
    onSecondary: Color(0xFF05070C),
    accent: Color(0xFF5E8CFF),
    background: Color(0xFF05070C),
    surface: Color(0xFF0B0F17),
    surfaceElevated: Color(0xFF141A29),
    border: Color(0x1AFFFFFF),
    borderStrong: Color(0x33FFFFFF),
    textPrimary: Color(0xFFF4F6FB),
    textSecondary: Color(0xFFA6ADBB),
    textTertiary: Color(0xFF6B7280),
    success: Color(0xFF2FD48E),
    warning: Color(0xFFF6C453),
    error: Color(0xFFF06B6B),
    info: Color(0xFF5E8CFF),
    overlay: Color(0x99000000),
    glow: Color(0x663563E9),
  );

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    primary: Color(0xFF2B52D6),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF54607A),
    onSecondary: Color(0xFFFFFFFF),
    accent: Color(0xFF2B52D6),
    background: Color(0xFFF6F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFBFCFF),
    border: Color(0x14000000),
    borderStrong: Color(0x24000000),
    textPrimary: Color(0xFF13151C),
    textSecondary: Color(0xFF545C70),
    textTertiary: Color(0xFF8A90A0),
    success: Color(0xFF0E8F63),
    warning: Color(0xFFB4790A),
    error: Color(0xFFD9433C),
    info: Color(0xFF2B52D6),
    overlay: Color(0x66000000),
    glow: Color(0x332B52D6),
  );
}
