import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Builds a full [ThemeData] from an [AppPalette] token set. Every component
/// theme is set explicitly (not inherited defaults) so light/dark stay
/// intentional rather than a blanket color inversion.
class AppTheme {
  const AppTheme._();

  static ThemeData build(AppPalette palette) {
    final scheme = ColorScheme(
      brightness: palette.brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.onSecondary,
      error: palette.error,
      onError: palette.onPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      surfaceContainerHighest: palette.surfaceElevated,
      outline: palette.border,
      outlineVariant: palette.borderStrong,
    );

    final textTheme = AppTypography.textTheme(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(color: palette.border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: palette.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.primary.withValues(alpha: 0.3),
          disabledForegroundColor: palette.onPrimary.withValues(alpha: 0.6),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.borderStrong),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        hintStyle: textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: palette.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: palette.error),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: palette.background,
        indicatorColor: palette.primary.withValues(alpha: 0.14),
        selectedIconTheme: IconThemeData(color: palette.primary),
        unselectedIconTheme: IconThemeData(color: palette.textSecondary),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: palette.primary),
        unselectedLabelTextStyle: textTheme.labelMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.primary.withValues(alpha: 0.14),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? textTheme.labelSmall?.copyWith(color: palette.primary)
              : textTheme.labelSmall,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surface,
        // Explicit (not the Material 3 default secondaryContainer) — our
        // secondary token is a dark steel tone, which combined with the
        // default labelStyle color below made a selected chip's label
        // unreadable against it.
        selectedColor: palette.primary.withValues(alpha: 0.14),
        side: BorderSide(color: palette.border),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: palette.primary, fontWeight: FontWeight.w600),
        checkmarkColor: palette.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: palette.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: palette.primary),
      iconTheme: IconThemeData(color: palette.textPrimary),
      extensions: [AppSemanticColors.fromPalette(palette)],
    );
  }
}

/// Extra tokens Material's [ColorScheme] has no slot for (success/warning,
/// glow, overlay) exposed via ThemeExtension so widgets read them through
/// `Theme.of(context).extension<AppSemanticColors>()` instead of importing
/// palettes directly.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.glow,
    required this.overlay,
    required this.surfaceElevated,
    required this.border,
    required this.textTertiary,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color glow;
  final Color overlay;
  final Color surfaceElevated;
  final Color border;
  final Color textTertiary;

  factory AppSemanticColors.fromPalette(AppPalette p) => AppSemanticColors(
        success: p.success,
        warning: p.warning,
        info: p.info,
        glow: p.glow,
        overlay: p.overlay,
        surfaceElevated: p.surfaceElevated,
        border: p.border,
        textTertiary: p.textTertiary,
      );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? glow,
    Color? overlay,
    Color? surfaceElevated,
    Color? border,
    Color? textTertiary,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      glow: glow ?? this.glow,
      overlay: overlay ?? this.overlay,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      textTertiary: textTertiary ?? this.textTertiary,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
    );
  }
}
