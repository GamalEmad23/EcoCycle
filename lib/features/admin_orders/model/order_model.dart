import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String center;
  final String material;
  final int weight;
  final String status;
  final DateTime date;
  final String? userName;
  final String? userEmail;

  OrderModel({
    required this.id,
    required this.userId,
    required this.center,
    required this.material,
    required this.weight,
    required this.status,
    required this.date,
    this.userName,
    this.userEmail,
  });

  factory OrderModel.fromFirestore(
      DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,
      userId: userId,
      center: data['center'] ?? '',
      material: data['material'] ?? '',
      weight: (data['weight'] as num?)?.toInt() ?? 0, // 🔥 FIX
      status: data['status'] ?? 'pending',
      userName: data['userName'],
      userEmail: data['userEmail'],
      date: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}