import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_cycle/core/utils/recycling_material.dart';

class RecyclingRequestModel {
  final String? id;
  final String material;
  final String? center;
  final double weight;
  final String? userId;
  final String status;
  final DateTime? createdAt;

  final String? imageUrl;

  RecyclingRequestModel({
    this.id,
    required this.material,
    this.center,
    required this.weight,
    this.userId,
    this.status = 'pending',
    this.createdAt,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'material': RecyclingMaterial.normalize(material),
      'center': center,
      'weight': weight,
      'userId': userId,
      'status': status,
      'imageUrl': imageUrl,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory RecyclingRequestModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return RecyclingRequestModel(
      id: documentId,
      material: RecyclingMaterial.normalize(map['material']?.toString() ?? ''),
      center: map['center'],
      weight: (map['weight'] ?? 0).toDouble(),
      userId: map['userId'],
      status: map['status'] ?? 'pending',
      imageUrl: map['imageUrl'], // 👈 الجديد
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
