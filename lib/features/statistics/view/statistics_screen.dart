import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
        backgroundColor: Colors.white,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
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
                      child: smallCard(
                        "statistics.co2_saved",
                        "18.2",
                        "12%+ ${"statistics.this_month".tr()}",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: smallCard(
                        "statistics.operations_count",
                        "12",
                        "2%+ ${"statistics.this_month".tr()}",
                        showUnit: false,
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
                        color: Colors.grey.withOpacity(0.15),
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

              /// النشاط الأخير
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

  /// كارت صغير
  Widget smallCard(
    String title,
    String value,
    String subtitle, {
    bool showUnit = true,
  }) {
    return Container(
      height: 106,
      width: 173,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomeText(
              text: title,
              textColor: AppColors.textGrey,
              fontSize: 12,
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                if (showUnit)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: const CustomeText(
                      text: "statistics.kg",
                      fontSize: 12,
                      textColor: AppColors.textGrey,
                    ),
                  ),
              ],
            ),
            CustomeText(
              text: subtitle,
              fontSize: 12,
              textColor: AppColors.Textcolor,
            ),
          ],
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
          icon: Icons.description,
          iconBg: Color(0xFFDCE8FF),
          iconColor: Colors.blue,
        ),
        SizedBox(height: 12),
        ActivityItem(
          title: "statistics.plastic_bottles",
          subtitle: "أمس • محطة الياسمين",
          weight: "1.8",
          points: "+12 نقطة",
          icon: Icons.local_drink,
          iconBg: Color(0xFFDDF5F0),
          iconColor: Colors.teal,
        ),
        SizedBox(height: 12),
        ActivityItem(
          title: "statistics.metal_cans",
          subtitle: "قبل يومين • محطة النور",
          weight: "0.5",
          points: "+8 نقاط",
          icon: Icons.inventory_2,
          iconBg: Color(0xFFFFE9D6),
          iconColor: Colors.orange,
        ),
      ],
    );
  }
}

/// العنصر
class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String weight;
  final String points;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.weight,
    required this.points,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// الأيقونة (يمين)
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 12),

          /// النص
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomeText(text: title, fontWeight: FontWeight.bold),
                const SizedBox(height: 4),
                CustomeText(text: subtitle, textColor: Colors.grey.shade600),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// الأرقام (شمال)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("كجم"),
                  const SizedBox(width: 4),
                  Text(
                    weight,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                points,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





























/*import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // حل مشكلة الاتجاه
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: CustomeText(
            text: "statistic.title",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: AppColors.white,
          centerTitle: true,
          elevation: 0,
        ),

        /// حل مشكلة overflow
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// الكارت الكبير
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
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
                            Text(
                              "إجمالي المعاد تدويره",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textGrey,
                              ),
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
                              child: Text(
                                "5%+",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "45",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "كجم",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// الكروت الصغيرة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: smallCard("توفير CO2", "18.2", "12%+ هذا الشهر"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: smallCard("عدد العمليات", "12", "2%+ هذا الشهر"),
                    ),
                  ],
                ),
              ),

              /// التقدم الشهري
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 250,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "التقدم الشهري",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text("آخر 6 أشهر"),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          MonthText("يناير"),
                          MonthText("فبراير"),
                          MonthText("مارس"),
                          MonthText("أبريل"),
                          MonthText("مايو"),
                          MonthText("يونيو"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// النشاط الأخير
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "النشاط الأخير",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "عرض الكل",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// القائمة
              const Padding(
                padding: EdgeInsets.all(16),
                child: RecentActivityList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// كارت صغير
  Widget smallCard(String title, String value, String subtitle) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: AppColors.textGrey)),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                const Text("كجم"),
              ],
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryLight,
              ),
            ),
          ],
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
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
          title: "مخلفات ورقية",
          subtitle: "منذ ساعتين • محطة وسط المدينة",
          weight: "2.5",
          points: "+15 نقطة",
          icon: Icons.description,
          iconBg: Color(0xFFDCE8FF),
          iconColor: Colors.blue,
        ),
        SizedBox(height: 12),
        ActivityItem(
          title: "زجاجات بلاستيكية",
          subtitle: "أمس • محطة الياسمين",
          weight: "1.8",
          points: "+12 نقطة",
          icon: Icons.local_drink,
          iconBg: Color(0xFFDDF5F0),
          iconColor: Colors.teal,
        ),
        SizedBox(height: 12),
        ActivityItem(
          title: "علب معدنية",
          subtitle: "قبل يومين • محطة النور",
          weight: "0.5",
          points: "+8 نقاط",
          icon: Icons.inventory_2,
          iconBg: Color(0xFFFFE9D6),
          iconColor: Colors.orange,
        ),
      ],
    );
  }
}

/// العنصر
class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String weight;
  final String points;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.weight,
    required this.points,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// الأيقونة (يمين)
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 12),

          /// النص
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// الأرقام (شمال)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("كجم"),
                  const SizedBox(width: 4),
                  Text(weight,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text(points,
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}*/