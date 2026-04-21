import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';

class RecyclingFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadRecyclingRequest({
    required RecyclingRequestModel requestModel,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      
      if (userId == null) {
        throw Exception('User must be logged in to create a request');
      }

      // Save data to the user's specific subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('recycling_requests')
          .add(requestModel.toMap());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }
}
