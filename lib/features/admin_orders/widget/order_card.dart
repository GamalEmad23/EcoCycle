import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/order_model.dart';
import '../order_cubit.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  Color getStatusColor() {
    switch (order.status) {
      case "accepted":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
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
    final cubit = context.read<OrderCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
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
                    Text(order.center,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.15),
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

                Text("${"admin_orders.material".tr()}: ${order.material}"),
                Text("${"admin_orders.weight".tr()}: ${order.weight} ${"admin_orders.kg".tr()}"),

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
                            backgroundColor: Colors.green,
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
                            backgroundColor: Colors.red,
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