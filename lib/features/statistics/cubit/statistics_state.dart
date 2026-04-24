import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:meta/meta.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsSuccess extends StatisticsState {
  final double totalWeight;
  final int operationsCount;
  final double co2Saved;
  final List<RecyclingRequestModel> recentActivities;

  final String weightTrend;
  final String co2Trend;
  final String operationsTrend;
  final List<double> chartData;

  StatisticsSuccess({
    required this.totalWeight,
    required this.operationsCount,
    required this.co2Saved,
    required this.recentActivities,
    required this.weightTrend,
    required this.co2Trend,
    required this.operationsTrend,
    required this.chartData,
  });
}

final class StatisticsFailure extends StatisticsState {
  final String message;

  StatisticsFailure({required this.message});
}
