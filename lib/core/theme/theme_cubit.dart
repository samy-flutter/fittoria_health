import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/preferences_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final PreferencesHelper _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeStr = _prefs.getThemeMode();
    if (themeStr == 'dark') {
      emit(ThemeMode.dark);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      emit(ThemeMode.light);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      await _prefs.setThemeMode('dark');
      emit(ThemeMode.dark);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      await _prefs.setThemeMode('light');
      emit(ThemeMode.light);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
  }
}
