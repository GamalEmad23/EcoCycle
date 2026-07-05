import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';

void main() {
  group('ThemeCubit Tests', () {
    late ThemeCubit themeCubit;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('initial state is ThemeMode.light', () {
      expect(themeCubit.state, ThemeMode.light);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.light] when loadTheme is called and no preference is saved',
      build: () => themeCubit,
      act: (cubit) => cubit.loadTheme(),
      expect: () => [ThemeMode.light],
      verify: (_) {
        expect(AppColors.isDarkMode, false);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.dark] when loadTheme is called and dark mode is saved in SharedPreferences',
      build: () {
        SharedPreferences.setMockInitialValues({'isDark': true});
        return ThemeCubit();
      },
      act: (cubit) => cubit.loadTheme(),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        expect(AppColors.isDarkMode, true);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.dark] when toggleTheme is called from light mode',
      build: () => themeCubit,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        expect(AppColors.isDarkMode, true);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'emits [ThemeMode.light] when toggleTheme is called from dark mode',
      build: () {
        // We simulate that the cubit is already in dark mode state.
        // But since we can't emit easily without internal method, we can toggle twice or seed it.
        // The easiest way is to call toggleTheme twice in the act phase or just check the transition.
        return ThemeCubit();
      },
      seed: () => ThemeMode.dark,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
      verify: (_) {
        expect(AppColors.isDarkMode, false);
      },
    );
  });
}
