// ignore_for_file: unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
    : super(ProfileLanguageState(locale: Locale('en'), langCode: 'en'));

  double Tpoints = 0;

  Future<void> changeLanguage(BuildContext context, String langCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('lang', langCode);

    final locale = Locale(langCode);
    await context.setLocale(locale);

    emit(ProfileLanguageState(locale: locale, langCode: langCode));
  }

  Future<void> getSavedLang(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String langCode = prefs.getString("lang") ?? "en";

    final locale = Locale(langCode);
    await context.setLocale(locale);
    emit(ProfileLanguageState(locale: locale, langCode: langCode));
  }

  Future<void> getProfileData() async {
    emit(profileDataLoading());

    try {
      var instance = await FirebaseFirestore.instance;
      var userUid = await FirebaseAuth.instance.currentUser!.uid;
      var snapshot = await instance
          .collection('users')
          .doc(userUid)
          .collection('recycling_requests')
          .get();

      var dataList = snapshot.docs.map((doc) => doc.data()).toList();
      emit(profileDataSuccess(profileData: dataList));
    } catch (e) {
      emit(profileDataFailuer(message: e.toString()));
    }
  }

  Future<void> getUserName() async {
    emit(userNameLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(userNameFailuer(message: "User not found"));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final name = snapshot.data()?['name'] ?? "No Name";

      emit(userNameSuccess(userName: name));
    } catch (e) {
      emit(userNameFailuer(message: e.toString()));
    }
  }

  Future<void> getUserStats() async {
    emit(ProfileStatsLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recycling_requests')
          .get();

      double totalWeight = 0;
      int totalRequests = snapshot.docs.length;

      for (var doc in snapshot.docs) {
        var data = doc.data();

        double weight = (data['weight'] ?? 0).toDouble();
        totalWeight += weight;
      }

      double points = totalWeight * 5;
      Tpoints = points;

      emit(
        ProfileStatsSuccess(
          totalWeight: totalWeight,
          totalRequests: totalRequests,
          points: points,
        ),
      );
    } catch (e) {
      emit(ProfileStatsFailuer(message: e.toString()));
    }
  }

  String getRank(double points) {
    if (points >= 100000) return "diamond";
    if (points >= 50000) return "platinum";
    if (points >= 20000) return "gold";
    if (points >= 10000) return "silver";
    if (points >= 2000) return "bronze";
    return "beginner";
  }

  IconData getRankIcon(double points) {
    if (points >= 100000) return Icons.diamond;
    if (points >= 50000) return Icons.workspace_premium;
    if (points >= 20000) return Icons.emoji_events;
    if (points >= 10000) return Icons.star;
    if (points >= 2000) return Icons.military_tech;
    return Icons.person;
  }

  Color getRankColor(double points) {
    if (points >= 100000) return Colors.blueAccent; // diamond
    if (points >= 50000) return Colors.grey; // platinum
    if (points >= 20000) return Colors.amber; // gold
    if (points >= 10000) return Colors.grey.shade400; // silver
    if (points >= 2000) return Colors.brown; // bronze
    return Colors.green; // beginner
  }
}
