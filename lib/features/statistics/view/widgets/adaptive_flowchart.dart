import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class ProgressFlowchartWidget extends StatelessWidget {
  final double weight;
  final double co2;
  final int operations;
  final double points;
  final String dateRange;

  const ProgressFlowchartWidget({
    super.key,
    required this.weight,
    required this.co2,
    required this.operations,
    required this.points,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    final dateRangeText = dateRange.tr();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.alt_route_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              CustomeText(
                text: 'flowchart.title',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                textColor: AppColors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.circleLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  dateRangeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: AppColors.isDarkMode ? 0.22 : 0.05,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildNodeCard(
                  icon: Icons.recycling,
                  iconColor: Colors.green,
                  iconBg: const Color(0xFFE8F5E9),
                  titleKey: 'flowchart.deposited',
                  subtitleKey: 'flowchart.deposited_desc',
                  value: "${weight.toStringAsFixed(1)} ${"statistics.kg".tr()}",
                  valueColor: Colors.green,
                ),

                _buildConnectorLine(),

                _buildNodeCard(
                  icon: Icons.eco_outlined,
                  iconColor: Colors.teal,
                  iconBg: const Color(0xFFE0F2F1),
                  titleKey: 'flowchart.offset',
                  subtitleKey: 'flowchart.offset_desc',
                  value: "${co2.toStringAsFixed(1)} ${"statistics.kg".tr()}",
                  valueColor: Colors.teal,
                ),

                _buildConnectorLine(),

                _buildNodeCard(
                  icon: Icons.assignment_turned_in_outlined,
                  iconColor: Colors.blue,
                  iconBg: const Color(0xFFE3F2FD),
                  titleKey: 'flowchart.processes',
                  subtitleKey: 'flowchart.processes_desc',
                  value: "$operations",
                  valueColor: Colors.blue,
                ),

                _buildConnectorLine(),

                _buildNodeCard(
                  icon: Icons.stars_rounded,
                  iconColor: Colors.amber.shade700,
                  iconBg: const Color(0xFFFFF8E1),
                  titleKey: 'flowchart.reward',
                  subtitleKey: 'flowchart.reward_desc',
                  value: "+${points.toInt()} ${"statistics.points".tr()}",
                  valueColor: Colors.amber.shade800,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String titleKey,
    required String subtitleKey,
    required String value,
    required Color valueColor,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.lightGreen3 : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? AppColors.primary : AppColors.border,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitleKey.tr(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectorLine() {
    return Container(
      height: 24,
      width: 2,
      decoration: BoxDecoration(color: AppColors.border),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 14,
            color: AppColors.textGrey.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
