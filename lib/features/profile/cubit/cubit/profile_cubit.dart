// ignore_for_file: unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLanguageState(locale: Locale('en'), langCode: 'en'));


  Future<void> changeLanguage(BuildContext context, String langCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('lang', langCode);

    final locale = Locale(langCode);
    await context.setLocale(locale);

    emit(ProfileLanguageState( locale: locale, langCode: langCode));
  }

  Future<void> getSavedLang(BuildContext context)async{
    final prefs = await SharedPreferences.getInstance();
    String langCode= prefs.getString("lang") ?? "en";
    

    final locale = Locale(langCode);
    await context.setLocale(locale);
    emit(ProfileLanguageState(locale: locale, langCode: langCode));
  }
}
