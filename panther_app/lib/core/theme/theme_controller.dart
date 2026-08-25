import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User's theme choice. [system] follows the OS setting.
enum AppThemeMode { system, light, dark }

const _prefsKey = 'panther.theme_mode';

/// Holds the active [AppThemeMode], persists it, and notifies listeners so
/// [MaterialApp] can rebuild with the new [ThemeMode]. Kept deliberately
/// separate from [ThemeData] construction (see app_theme.dart) so theme
/// *choice* and theme *tokens* don't get tangled together.
class ThemeController extends ChangeNotifier {
  ThemeController() {
    _load();
  }

  AppThemeMode _mode = AppThemeMode.system;
  AppThemeMode get mode => _mode;

  ThemeMode get flutterThemeMode => switch (_mode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_prefsKey);
      if (stored != null) {
        _mode = AppThemeMode.values.firstWhere(
          (m) => m.name == stored,
          orElse: () => AppThemeMode.system,
        );
        notifyListeners();
      }
    } catch (_) {
      // Persistence is a nicety, not a requirement — fall back silently to
      // the in-memory default (system) if storage is unavailable.
    }
  }

  Future<void> setMode(AppThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, mode.name);
    } catch (_) {
      // Ignore — see _load().
    }
  }
}
