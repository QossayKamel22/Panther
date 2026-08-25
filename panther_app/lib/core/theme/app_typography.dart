import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Type scale — large, confident display sizes and a calm body size,
/// following iOS-style hierarchy rather than dense "web app" typography.
/// Uses the platform system font stack (SF Pro on Apple platforms, Roboto on
/// Android, system-ui on web) so the app never blocks on a font download.
class AppTypography {
  const AppTypography._();

  static const String fontFamily = '.SF Pro Text';
  static const List<String> fontFamilyFallback = [
    'Roboto',
    'Segoe UI',
    'Helvetica Neue',
    'Arial',
  ];

  static TextTheme textTheme(AppPalette palette) {
    final base = TextTheme(
      displayLarge: _style(40, FontWeight.w700, -0.5, palette.textPrimary),
      displayMedium: _style(32, FontWeight.w700, -0.4, palette.textPrimary),
      displaySmall: _style(28, FontWeight.w600, -0.3, palette.textPrimary),
      headlineLarge: _style(24, FontWeight.w600, -0.2, palette.textPrimary),
      headlineMedium: _style(20, FontWeight.w600, -0.1, palette.textPrimary),
      headlineSmall: _style(18, FontWeight.w600, 0, palette.textPrimary),
      titleLarge: _style(17, FontWeight.w600, 0, palette.textPrimary),
      titleMedium: _style(15, FontWeight.w600, 0, palette.textPrimary),
      titleSmall: _style(13, FontWeight.w600, 0.1, palette.textSecondary),
      bodyLarge: _style(16, FontWeight.w400, 0, palette.textPrimary),
      bodyMedium: _style(14, FontWeight.w400, 0, palette.textSecondary),
      bodySmall: _style(12, FontWeight.w400, 0.1, palette.textTertiary),
      labelLarge: _style(14, FontWeight.w600, 0.1, palette.textPrimary),
      labelMedium: _style(12, FontWeight.w600, 0.2, palette.textSecondary),
      labelSmall: _style(11, FontWeight.w600, 0.4, palette.textTertiary),
    );
    return base;
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    double letterSpacing,
    Color color,
  ) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: color,
      height: 1.3,
    );
  }
}
