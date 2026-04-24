import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;
  OrderSuccess(this.orders);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  void getOrders(String status) async {
    try {
      emit(OrderLoading());

      final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      List<OrderModel> allOrders = [];

      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('recycling_requests')
            .get();

        for (var doc in ordersSnapshot.docs) {
          final order =
          OrderModel.fromFirestore(doc, userDoc.id);

          if (status == "all" || order.status == status) {
            allOrders.add(order);
          }
        }
      }

      emit(OrderSuccess(allOrders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('recycling_requests')
          .doc(orderId)
          .update({
        'status': newStatus,
      });
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}