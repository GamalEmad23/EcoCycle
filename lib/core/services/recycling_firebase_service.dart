import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:eco_cycle/core/data/centers_data.dart';

class RecyclingFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ existing function (بدون تعديل)
  Future<void> uploadRecyclingRequest({
    required RecyclingRequestModel requestModel,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId == null) {
        throw Exception('User must be logged in to create a request');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('recycling_requests')
          .add(requestModel.toMap());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  // 🔥 NEW FUNCTION: seed centers into Firestore
  Future<void> seedCenters() async {
    try {
      final collection = _firestore.collection('centers');

      for (var center in centers) {
        await collection.doc(center['name']).set(center);
      }

      print('Centers seeded successfully ✅');
    } catch (e) {
      throw Exception('Failed to seed centers: $e');
    }
  }
}
