import 'dart:async';

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  SharedPreferences? _prefs;

  Future<void> loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final isDark = _prefs!.getBool('isDark') ?? false;
    AppColors.isDarkMode = isDark;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    final nextTheme = isDark ? ThemeMode.light : ThemeMode.dark;

    AppColors.isDarkMode = nextTheme == ThemeMode.dark;
    emit(nextTheme);
    unawaited(_saveTheme(nextTheme));
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setBool('isDark', themeMode == ThemeMode.dark);
  }
}
