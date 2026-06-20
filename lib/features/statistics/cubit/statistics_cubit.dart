import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial());

  Future<void> getStatisticsData() async {
    emit(StatisticsLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(StatisticsFailure(message: "User not found"));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recycling_requests')
          .orderBy('createdAt', descending: true)
          .get();

      double totalWeight = 0;
      int operationsCount = snapshot.docs.length;
      List<RecyclingRequestModel> recentActivities = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        var model = RecyclingRequestModel.fromMap(data, doc.id);

        // ✅ Fix corrupted UTF-8 text if any exists
        final fixedMaterial = _fixUtf8Corruption(model.material);
        if (fixedMaterial != model.material) {
          model = RecyclingRequestModel(
            id: model.id,
            material: fixedMaterial,
            center: model.center,
            weight: model.weight,
            userId: model.userId,
            status: model.status,
            createdAt: model.createdAt,
            imageUrl: model.imageUrl,
          );
        }

        recentActivities.add(model);
        totalWeight += model.weight;
      }

      // Estimate CO2 saved: ~1.2 kg CO2 per 1 kg recycled material
      double co2Saved = totalWeight * 1.2;

      // Simple dynamic trend simulation based on count and total weight
      // In a real app, you would compare with previous period data
      String weightTrend = "+${(totalWeight * 0.1).toStringAsFixed(1)}%";
      String co2Trend = "+${(co2Saved * 0.08).toStringAsFixed(1)}%";
      String operationsTrend = "+${(operationsCount * 2)}%";

      // Calculate chart data (total weight per month for last 6 months)
      List<double> chartData = List.filled(6, 0.0);
      final now = DateTime.now();
      for (var activity in recentActivities) {
        if (activity.createdAt != null) {
          final difference = now.difference(activity.createdAt!).inDays;
          int monthIdx = 5 - (difference ~/ 30);
          if (monthIdx >= 0 && monthIdx < 6) {
            chartData[monthIdx] += activity.weight;
          }
        }
      }

      emit(
        StatisticsSuccess(
          totalWeight: totalWeight,
          operationsCount: operationsCount,
          co2Saved: co2Saved,
          recentActivities: recentActivities,
          weightTrend: weightTrend,
          co2Trend: co2Trend,
          operationsTrend: operationsTrend,
          chartData: chartData,
        ),
      );
    } catch (e) {
      emit(StatisticsFailure(message: e.toString()));
    }
  }

  Future<void> deleteActivity(String activityId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(StatisticsFailure(message: "User not found"));
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recycling_requests')
          .doc(activityId)
          .delete();

      // Refresh statistics data after deletion
      await getStatisticsData();
    } catch (e) {
      emit(StatisticsFailure(message: e.toString()));
    }
  }

  /// Fixes corrupted UTF-8 text (e.g., "Ø§Ù„Ù†Øµ" -> "النص")
  String _fixUtf8Corruption(String text) {
    try {
      // Check if text contains corruption markers (like "Ø" or "Ù„")
      if (!text.contains(RegExp(r'Ø|Ù|ï|¿'))) {
        return text; // Text is fine
      }
      // Interpret the malformed Dart string as Latin1 bytes, then decode as UTF-8
      // This mirrors: restored = mojibake.encode('latin-1').decode('utf-8')
      List<int> latinBytes = latin1.encode(text);
      return utf8.decode(latinBytes);
    } catch (e) {
      print("UTF-8 recovery failed: $e");
      return text; // Return original if recovery fails
    }
  }
}
