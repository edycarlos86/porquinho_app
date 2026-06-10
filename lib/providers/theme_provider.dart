import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box('settings');
    final value = box.get(_themeKey);

    if (value == 'light') {
      _themeMode = ThemeMode.light;
    } else if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  void setLight() {
    _themeMode = ThemeMode.light;
    _save('light');
  }

  void setDark() {
    _themeMode = ThemeMode.dark;
    _save('dark');
  }

  void setSystem() {
    _themeMode = ThemeMode.system;
    _save('system');
  }

  void _save(String value) {
    final box = Hive.box('settings');
    box.put(_themeKey, value);
    notifyListeners();
  }
}
