import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:eco_cycle/features/statistics/cubit/statistics_cubit.dart';
import 'package:eco_cycle/features/statistics/cubit/statistics_state.dart';
import 'package:eco_cycle/features/statistics/view/widgets/Activity_Item.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/statistics/view/widgets/Small_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isViewAll = false;
  String _selectedRange = "statistics.Last_months";

  @override
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().getStatisticsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.02),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        forceMaterialTransparency: true,
        centerTitle: false,
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],

        title: Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.lightGreen5,
                child: Image.asset(
                  "assets/images/appbar.png",
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              CustomeText(
                text: "EcoCycle",
                textColor: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),

      body: RefreshIndicator(
        color: AppColors.levelCardEnd,

        onRefresh: () async {
          await context.read<StatisticsCubit>().getStatisticsData();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: BlocBuilder<StatisticsCubit, StatisticsState>(
              builder: (context, state) {
                if (state is StatisticsLoading) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: LottieBuilder.asset(
                          "assets/lotties/Green eco earth animation.json",
                        ),
                      ),
                    ),
                  );
                }



                if (state is StatisticsFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Text(state.message),
                    ),
                  );
                }

                double totalWeight = 0;
                int operationsCount = 0;
                double co2Saved = 0;
                List<RecyclingRequestModel> recentActivities = [];


                // Trends and chart data from state
                String weightTrend = "+0%";
                String co2Trend = "+0%";
                String operationsTrend = "+0%";
                List<double> chartData = [0, 0, 0, 0, 0, 0];

                if (state is StatisticsSuccess) {
                  totalWeight = state.totalWeight;
                  operationsCount = state.operationsCount;
                  co2Saved = state.co2Saved;
                  recentActivities = state.recentActivities;
                  weightTrend = state.weightTrend;
                  co2Trend = state.co2Trend;
                  operationsTrend = state.operationsTrend;
                  chartData = state.chartData;
                }

                // Dynamic chart labels and SPOTS based on range
                List<String> chartLabels = [];
                List<FlSpot> chartSpots = [];
                final now = DateTime.now();

                if (_selectedRange == "statistics.last_week") {
                  chartLabels = List.generate(7, (i) {
                    final day = now.subtract(Duration(days: 6 - i));
                    return DateFormat('E').format(day);
                  });



                  // Calculate spots for last week based on operations count
                  List<double> dailyOps = List.filled(7, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      final diff = now.difference(activity.createdAt!).inDays;
                      if (diff >= 0 && diff < 7) {
                        dailyOps[6 - diff] += 1;
                      }
                    }
                  }
                  chartSpots = dailyOps
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList();

                } else if (_selectedRange == "statistics.today") {
                  // Every 3 hours: 12AM, 3AM, 6AM, 9AM, 12PM, 3PM, 6PM, 9PM
                  chartLabels = List.generate(8, (i) {
                    final hour = i * 3;
                    final time = DateTime(now.year, now.month, now.day, hour);
                    // Use locale-aware format for AM/PM
                    return DateFormat(
                      'ha',
                      context.locale.languageCode,
                    ).format(time);

                  });

                  // Calculate spots for today based on operations count
                  List<double> hourlyOps = List.filled(8, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      // Check if it's the same day
                      if (activity.createdAt!.year == now.year &&
                          activity.createdAt!.month == now.month &&

                          activity.createdAt!.day == now.day) {
                        int hour = activity.createdAt!.hour;
                        int slot = hour ~/ 3;
                        if (slot >= 0 && slot < 8) {
                          hourlyOps[slot] += 1;
                        }
                      }
                    }
                  }
                  chartSpots = hourlyOps
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList();

                } else if (_selectedRange == "statistics.last_month") {
                  chartLabels = List.generate(4, (i) {
                    return "${"statistics.week".tr()} ${i + 1}";
                  });

                  // Calculate spots for last month (4 weeks) based on operations count
                  List<double> weeklyOps = List.filled(4, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      final diffDays = now
                          .difference(activity.createdAt!)
                          .inDays;

                      if (diffDays >= 0 && diffDays < 28) {
                        int slot = diffDays ~/ 7;
                        if (slot >= 0 && slot < 4) {
                          weeklyOps[3 - slot] += 1;
                        }
                      }
                    }
                  }
                  chartSpots = weeklyOps
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList();
                } else {
                  // Default 6 months
                  chartLabels = List.generate(6, (i) {
                    final monthDate = DateTime(
                      now.year,
                      now.month - (5 - i),
                      1,
                    );

                    return DateFormat('MMM').format(monthDate);
                  });

                  // Calculate spots for 6 months based on operations count
                  List<double> monthlyOps = List.filled(6, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      final diffMonths =
                          (now.year - activity.createdAt!.year) * 12 +
                          now.month -
                          activity.createdAt!.month;

                      if (diffMonths >= 0 && diffMonths < 6) {
                        monthlyOps[5 - diffMonths] += 1;
                      }
                    }
                  }
                  chartSpots = monthlyOps
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList();
                }

                // Ensure chart looks nice if all values are zero
                if (chartSpots.every((spot) => spot.y == 0)) {
                  chartSpots = chartSpots
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), 0.1))
                      .toList();
                }





                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(21.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomeText(
                                    text: "statistics.total_recycled",
                                    fontSize: 14,
                                    textColor: AppColors.textGrey,
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreen3,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/top.png"),
                                        CustomeText(
                                          text: weightTrend,
                                          fontSize: 12,
                                          textColor: AppColors.Textcolor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomeText(
                                    text: totalWeight.toStringAsFixed(1),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: CustomeText(
                                      text: "statistics.kg",
                                      fontSize: 18,
                                      textColor: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: SmallCard(
                              title: "statistics.co2_saved",
                              value: co2Saved.toStringAsFixed(1),
                              subtitle:
                                  "$co2Trend ${"statistics.this_month".tr()}",

                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SmallCard(
                              showUnit: false,
                              title: "statistics.operations_count",
                              value: operationsCount.toString(),
                              subtitle:
                                  "$operationsTrend ${"statistics.this_month".tr()}",

                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 250,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomeText(
                                  text: "statistics.progress",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                PopupMenuButton<String>(

                                  onSelected: (value) {
                                    setState(() {
                                      _selectedRange = value;
                                    });
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: "statistics.today",
                                      child: Text("statistics.today".tr()),
                                    ),
                                    PopupMenuItem(
                                      value: "statistics.last_week",
                                      child: Text("statistics.last_week".tr()),
                                    ),
                                    PopupMenuItem(
                                      value: "statistics.last_month",
                                      child: Text("statistics.last_month".tr()),
                                    ),
                                    PopupMenuItem(
                                      value: "statistics.Last_months",
                                      child: Text(
                                        "statistics.Last_months".tr(),
                                      ),
                                    ),

                                  ],
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.circleLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: CustomeText(
                                      text: _selectedRange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 120,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: chartSpots,
                                      isCurved: true,
                                      color: AppColors.primaryLight,
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.primaryLight
                                            .withValues(alpha: 0.1),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: chartLabels
                                  .map((label) => MonthText(label))
                                  .toList(),

                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          CustomeText(
                            text: "statistics.latest_activity",
                            fontSize: 16,
                            textColor: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isViewAll = !_isViewAll;
                              });
                            },
                            child: CustomeText(
                              text: _isViewAll
                                  ? "statistics.show_less"
                                  : "statistics.view_all",
                              fontSize: 14,
                              textColor: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// القائمة
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      child: RecentActivityList(
                        activities: _isViewAll
                            ? recentActivities
                            : recentActivities.take(3).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// الشهور
class MonthText extends StatelessWidget {
  final String text;
  const MonthText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomeText(
      text: text,
      fontSize: 12,
      textColor: Colors.grey.shade700,
    );
  }
}

/// القائمة
class RecentActivityList extends StatelessWidget {
  final List<RecyclingRequestModel> activities;
  const RecentActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("statistics.no_activities".tr()),
        ),
      );
    }

    return Column(
      children: activities.map((activity) {
        String title = activity.material;
        String subtitle = activity.center ?? "";
        String weight = activity.weight.toString();


        String imagePath = "assets/images/plastic.png";
        Color iconBg = const Color(0xFFDDF5F0);
        Color iconColor = Colors.teal;
        String translatedTitle = title;

        // Generalized translation logic: try to find a key for any subtitle
        String centerKey = subtitle.toLowerCase().trim().replaceAll(' ', '_');


        // Check if there's a specific translation key for this center name
        if ("statistics.$centerKey".tr() != "statistics.$centerKey") {
          subtitle = "statistics.$centerKey".tr();
        } else if ("add_process.$centerKey".tr() != "add_process.$centerKey") {
          subtitle = "add_process.$centerKey".tr();
          subtitle = "map.$centerKey".tr();
        } else {
          // Check for common variations or manual overrides
          if (subtitle.toLowerCase().contains("go clean egypt")) {
            subtitle = "statistics.go_clean_egypt".tr();
          } else if (subtitle.toLowerCase().contains("green recycle")) {
            subtitle = "statistics.green_recycle".tr();
          }
        }


        if (title.contains("ورق") || title.toLowerCase().contains("paper")) {
          translatedTitle = "statistics.paper".tr();
          imagePath = "assets/images/description.png";
          iconBg = const Color(0xFFDCE8FF);
          iconColor = Colors.blue;
        } else if (title.contains("معدن") ||
            title.toLowerCase().contains("metal")) {
          translatedTitle = "statistics.metal".tr();
          imagePath = "assets/images/metal.png";
          iconBg = const Color(0xFFFFE9D6);
          iconColor = Colors.orange;
        } else if (title.contains("بلاستيك") ||
            title.toLowerCase().contains("plastic")) {
          translatedTitle = "statistics.plastic".tr();
          imagePath = "assets/images/plastic.png";
          iconBg = const Color(0xFFDDF5F0);
          iconColor = Colors.teal;
        } else if (title.contains("إلكترونيات") ||
            title.toLowerCase().contains("electronics")) {
          translatedTitle = "statistics.electronics".tr();
          imagePath =
              "assets/images/description.png"; // Fallback to description icon
          iconBg = const Color(0xFFF3E5F5);
          iconColor = Colors.purple;

        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ActivityItem(
            title: translatedTitle,
            subtitle: subtitle,
            weight: weight,
            points:
                "+${(activity.weight * 5).toInt()} ${"statistics.points".tr()}",

            imagePath: imagePath,
            iconBg: iconBg,
            iconColor: iconColor,
          ),
        );
      }).toList(),
    );
  }
}
