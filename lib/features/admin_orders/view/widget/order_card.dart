import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/order_cubit.dart';
import '../../model/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  Color getStatusColor() {
    switch (order.status) {
      case "accepted":
        return AppColors.green;
      case "rejected":
        return AppColors.red;
      default:
        return AppColors.orange;
    }
  }

  String getStatusText() {
    switch (order.status) {
      case "accepted":
        return "orders.accepted".tr();
      case "rejected":
        return "orders.rejected".tr();
      default:
        return "orders.pending".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppColors.isDarkMode = isDark;
    final cardColor = isDark ? const Color(0xFF141A16) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF233027)
        : const Color(0xFFE5E7EB);
    final cubit = context.read<OrderCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              "assets/images/Image+Background.png",
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor().withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusText(),
                        style: TextStyle(color: getStatusColor()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "${"admin_orders.material".tr()}: ${order.material}",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  "${"admin_orders.weight".tr()}: ${order.weight} ${"admin_orders.kg".tr()}",
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 10),

                if (order.status == "pending")
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await cubit.updateOrderStatus(
                              userId: order.userId,
                              orderId: order.id,
                              newStatus: "accepted",
                            );

                            cubit.getOrders("all");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("admin_orders.accept".tr()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await cubit.updateOrderStatus(
                              userId: order.userId,
                              orderId: order.id,
                              newStatus: "rejected",
                            );

                            cubit.getOrders("all");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("admin_orders.reject".tr()),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
