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
}
