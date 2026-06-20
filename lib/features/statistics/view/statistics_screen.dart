import 'package:eco_cycle/core/services/notification_service.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_lang_card.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:eco_cycle/features/statistics/cubit/statistics_cubit.dart';
import 'package:eco_cycle/features/statistics/cubit/statistics_state.dart';
import 'package:eco_cycle/features/statistics/view/widgets/Activity_Item.dart';
import 'package:eco_cycle/features/statistics/view/widgets/adaptive_flowchart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/statistics/view/widgets/Small_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:eco_cycle/core/utils/recycling_material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isViewAll = false;
  String _selectedRange = "statistics.Last_months";
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().getStatisticsData();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    final count = await NotificationService().getUnreadCount();
    if (mounted) setState(() => _unreadCount = count);
  }

  Future<void> _clearNotifications() async {
    await NotificationService().clearUnreadCount();
    if (mounted) setState(() => _unreadCount = 0);
  }

  // ── Notifications bottom sheet ──────────────────────────────────────────────
  void _showNotificationsSheet() async {
    await _clearNotifications();
    final history = await NotificationService().getHistory();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotificationsSheet(messages: history),
    );
  }

  // ── Settings bottom sheet ───────────────────────────────────────────────────
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SettingsSheet(),
    );
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
              // ── Bell icon with badge ──
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _showNotificationsSheet,
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          _unreadCount > 99 ? '99+' : '$_unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // ── Settings icon ──
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: _showSettingsSheet,
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

                // Calculate period-specific stats for the Progress Flowchart
                double periodWeight = 0;
                int periodOperations = 0;
                double periodCo2 = 0;
                double periodPoints = 0;

                if (recentActivities.isNotEmpty) {
                  final now = DateTime.now();
                  List<RecyclingRequestModel> filteredActivities = [];

                  if (_selectedRange == "statistics.today") {
                    filteredActivities = recentActivities.where((a) {
                      if (a.createdAt == null) return false;
                      return a.createdAt!.year == now.year &&
                             a.createdAt!.month == now.month &&
                             a.createdAt!.day == now.day;
                    }).toList();
                  } else if (_selectedRange == "statistics.last_week") {
                    final weekAgo = now.subtract(const Duration(days: 7));
                    filteredActivities = recentActivities.where((a) {
                      if (a.createdAt == null) return false;
                      return a.createdAt!.isAfter(weekAgo);
                    }).toList();
                  } else if (_selectedRange == "statistics.last_month") {
                    final monthAgo = now.subtract(const Duration(days: 30));
                    filteredActivities = recentActivities.where((a) {
                      if (a.createdAt == null) return false;
                      return a.createdAt!.isAfter(monthAgo);
                    }).toList();
                  } else {
                    // Last 6 months
                    final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
                    filteredActivities = recentActivities.where((a) {
                      if (a.createdAt == null) return false;
                      return a.createdAt!.isAfter(sixMonthsAgo);
                    }).toList();
                  }

                  periodOperations = filteredActivities.length;
                  for (var a in filteredActivities) {
                    periodWeight += a.weight;
                  }
                  periodCo2 = periodWeight * 1.2;
                  periodPoints = periodWeight * 5;
                }

                // Dynamic chart labels and SPOTS based on range
                List<String> chartLabels = [];
                List<FlSpot> chartSpots = [];
                final nowForChart = DateTime.now();

                if (_selectedRange == "statistics.last_week") {
                  chartLabels = List.generate(7, (i) {
                    final day = nowForChart.subtract(Duration(days: 6 - i));
                    return DateFormat('E', context.locale.languageCode).format(day);
                  });

                  // Calculate spots for last week based on cumulative operations count
                  List<double> dailyOps = List.filled(7, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      final diff = nowForChart.difference(activity.createdAt!).inDays;
                      if (diff >= 0 && diff < 7) {
                        dailyOps[6 - diff] += 1;
                      }
                    }
                  }
                  // Make cumulative
                  double sum = 0;
                  for (int i = 0; i < dailyOps.length; i++) {
                    sum += dailyOps[i];
                    dailyOps[i] = sum;
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
                    final time = DateTime(nowForChart.year, nowForChart.month, nowForChart.day, hour);
                    // Use locale-aware format for AM/PM
                    return DateFormat(
                      'ha',
                      context.locale.languageCode,
                    ).format(time);
                  });

                  // Calculate spots for today based on cumulative operations count
                  List<double> hourlyOps = List.filled(8, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      // Check if it's the same day
                      if (activity.createdAt!.year == nowForChart.year &&
                          activity.createdAt!.month == nowForChart.month &&
                          activity.createdAt!.day == nowForChart.day) {
                        int hour = activity.createdAt!.hour;
                        int slot = hour ~/ 3;
                        if (slot >= 0 && slot < 8) {
                          hourlyOps[slot] += 1;
                        }
                      }
                    }
                  }
                  // Make cumulative
                  double sum = 0;
                  for (int i = 0; i < hourlyOps.length; i++) {
                    sum += hourlyOps[i];
                    hourlyOps[i] = sum;
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

                  // Calculate spots for last month (4 weeks) based on cumulative operations count
                  List<double> weeklyOps = List.filled(4, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      final diffDays = nowForChart
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
                  // Make cumulative
                  double sum = 0;
                  for (int i = 0; i < weeklyOps.length; i++) {
                    sum += weeklyOps[i];
                    weeklyOps[i] = sum;
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
                      nowForChart.year,
                      nowForChart.month - (5 - i),
                      1,
                    );

                    return DateFormat('MMM', context.locale.languageCode).format(monthDate);
                  });

                  // Calculate spots for 6 months based on cumulative operations count
                  List<double> monthlyOps = List.filled(6, 0.0);
                  for (var activity in recentActivities) {
                    if (activity.createdAt != null) {
                      final diffMonths =
                          (nowForChart.year - activity.createdAt!.year) * 12 +
                          nowForChart.month -
                          activity.createdAt!.month;

                      if (diffMonths >= 0 && diffMonths < 6) {
                        monthlyOps[5 - diffMonths] += 1;
                      }
                    }
                  }
                  // Make cumulative
                  double sum = 0;
                  for (int i = 0; i < monthlyOps.length; i++) {
                    sum += monthlyOps[i];
                    monthlyOps[i] = sum;
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
                              color: AppColors.isDarkMode
                                  ? Colors.black.withValues(alpha: 0.22)
                                  : Colors.grey.withValues(alpha: 0.12),
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
                              color: AppColors.isDarkMode
                                  ? Colors.black.withValues(alpha: 0.22)
                                  : Colors.grey.withValues(alpha: 0.15),
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
                                CustomeText(
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

                    ProgressFlowchartWidget(
                      weight: periodWeight,
                      co2: periodCo2,
                      operations: periodOperations,
                      points: periodPoints,
                      dateRange: _selectedRange,
                    ),
                    const SizedBox(height: 16),

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
                        isViewAll: _isViewAll,
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
    return CustomeText(text: text, fontSize: 12, textColor: AppColors.textGrey);
  }
}

/// القائمة
class RecentActivityList extends StatelessWidget {
  final List<RecyclingRequestModel> activities;
  final bool isViewAll;
  const RecentActivityList({
    super.key,
    required this.activities,
    required this.isViewAll,
  });

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
        final material = RecyclingMaterial.normalize(title);
        String subtitle = activity.center ?? "";
        String weight = activity.weight.toString();

        String imagePath = "assets/images/plastic.png";
        Color iconBg = const Color(0xFFDDF5F0);
        Color iconColor = Colors.teal;
        String translatedTitle = RecyclingMaterial.displayName(title);

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

        if (material == RecyclingMaterial.paper) {
          translatedTitle = "statistics.paper".tr();
          imagePath = "assets/images/description.png";
          iconBg = const Color(0xFFDCE8FF);
          iconColor = Colors.blue;
        } else if (material == RecyclingMaterial.metal) {
          translatedTitle = "statistics.metal".tr();
          imagePath = "assets/images/metal.png";
          iconBg = const Color(0xFFFFE9D6);
          iconColor = Colors.orange;
        } else if (material == RecyclingMaterial.plastic) {
          translatedTitle = "statistics.plastic".tr();
          imagePath = "assets/images/plastic.png";
          iconBg = const Color(0xFFDDF5F0);
          iconColor = Colors.teal;
        } else if (material == RecyclingMaterial.electronics) {
          translatedTitle = "statistics.electronics".tr();
          imagePath =
              "assets/images/description.png"; // Fallback to description icon
          iconBg = const Color(0xFFF3E5F5);
          iconColor = Colors.purple;
        }

        final itemWidget = Padding(
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

        if (isViewAll) {
          return Dismissible(
            key: Key(activity.id ?? UniqueKey().toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) => AlertDialog(
                  backgroundColor: AppColors.white,
                  title: Text(
                    "statistics.delete_confirm_title".tr(),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "statistics.delete_confirm_content".tr(),
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text(
                        "buttons.cancel".tr(),
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(
                        "buttons.delete".tr(),
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              if (activity.id != null) {
                context.read<StatisticsCubit>().deleteActivity(activity.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${"buttons.delete".tr()}: $translatedTitle",
                    ),
                  ),
                );
              }
            },
            child: itemWidget,
          );
        }

        return itemWidget;
      }).toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Notifications Bottom Sheet
// ══════════════════════════════════════════════════════════════════════════════
class _NotificationsSheet extends StatelessWidget {
  final List<NotificationMessage> messages;
  const _NotificationsSheet({required this.messages});

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen3,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_active,
                      color: AppColors.primaryLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomeText(
                    text: 'الإشعارات',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  if (messages.isNotEmpty)
                    GestureDetector(
                      onTap: () async {
                        await NotificationService().clearHistory();
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: CustomeText(
                        text: 'مسح الكل',
                        fontSize: 13,
                        textColor: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: AppColors.border, height: 1),
            // Content
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: AppColors.textGrey.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          CustomeText(
                            text: 'لا توجد إشعارات',
                            fontSize: 16,
                            textColor: AppColors.textGrey,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: AppColors.border, height: 1),
                      itemBuilder: (_, i) {
                        final msg = messages[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen3,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text(
                                  '♻️',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      msg.body,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textGrey,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _formatTime(msg.time),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primaryLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Settings Bottom Sheet
// ══════════════════════════════════════════════════════════════════════════════
class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.35,
      maxChildSize: 0.7,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.iconBgLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomeText(
                    text: 'settings.title',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 16),

            // ── Dark / Light Mode ──────────────────────────────────────────
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (ctx, themeMode) {
                final isDark = themeMode == ThemeMode.dark;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => ctx.read<ThemeCubit>().toggleTheme(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E1E2E)
                                  : const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: isDark
                                  ? Colors.indigo
                                  : Colors.orangeAccent,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isDark ? 'settings.dark_mode'.tr() : 'settings.light_mode'.tr(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  isDark
                                      ? 'settings.switch_to_light'.tr()
                                      : 'settings.switch_to_dark'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isDark,
                            onChanged: (_) =>
                                ctx.read<ThemeCubit>().toggleTheme(),
                            activeThumbColor: AppColors.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ── Language ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CustomeText(
                      text: 'settings.choose_language',
                      fontSize: 14,
                      textColor: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  StatefulBuilder(
                    builder: (ctx, setSt) => Column(
                      children: [
                        // English
                        CustomeLangCard(
                          title: 'English',
                          icon: Icons.language,
                          selected: ctx.locale.languageCode == 'en',
                          onTap: () {
                            ctx.read<ProfileCubit>().changeLanguage(ctx, 'en');
                            setSt(() {});
                          },
                        ),
                        const SizedBox(height: 10),
                        // Arabic
                        CustomeLangCard(
                          title: 'العربية',
                          icon: Icons.language,
                          selected: ctx.locale.languageCode == 'ar',
                          onTap: () {
                            ctx.read<ProfileCubit>().changeLanguage(ctx, 'ar');
                            setSt(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
