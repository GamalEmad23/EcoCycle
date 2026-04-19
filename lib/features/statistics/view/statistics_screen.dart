import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/statistics/view/widgets/Activity_Item.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/statistics/view/widgets/Small_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                                    text: "+5%",

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
                            const CustomeText(
                              text: "45",

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
                        value: "18.2",
                        subtitle: "12%+ ${"statistics.this_month".tr()}",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SmallCard(
                        showUnit: false,
                        title: "statistics.operations_count",
                        value: "12",
                        subtitle: "2%+ ${"statistics.this_month".tr()}",
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
                            text: "statistics.Monthly_progress",

                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.circleLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const CustomeText(
                              text: "statistics.Last_months",
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          MonthText("statistics.jan"),
                          MonthText("statistics.feb"),
                          MonthText("statistics.mar"),
                          MonthText("statistics.apr"),
                          MonthText("statistics.may"),
                          MonthText("statistics.jun"),
                        ],
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
                    CustomeText(
                      text: "statistics.view_all",

                      fontSize: 14,
                      textColor: AppColors.primaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// القائمة
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: RecentActivityList(),
              ),
            ],
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
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ActivityItem(
          title: "statistics.paper_waste",
          subtitle: " • محطة وسط المدينة",
          weight: "2.5",
          points: "+15 نقطة",
          imagePath: "assets/images/description.png",
          iconBg: Color(0xFFDCE8FF),
          iconColor: Colors.blue,
        ),
        SizedBox(height: 12),
        ActivityItem(
          title: "statistics.plastic_bottles",
          subtitle: "أمس • محطة الياسمين",
          weight: "1.8",
          points: "+12 نقطة",
          imagePath: "assets/images/plastic.png",
          iconBg: Color(0xFFDDF5F0),
          iconColor: Colors.teal,
        ),
        SizedBox(height: 12),
        ActivityItem(
          title: "statistics.metal_cans",
          subtitle: "قبل يومين • محطة النور",
          weight: "0.5",
          points: "+8 نقاط",
          imagePath: "assets/images/metal.png",
          iconBg: Color(0xFFFFE9D6),
          iconColor: Colors.orange,
        ),
      ],
    );
  }
}

/// العنصر
