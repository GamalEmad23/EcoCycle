import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';

class RecyclingFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadRecyclingRequest({
    required RecyclingRequestModel requestModel,
  }) async {
    try {
      // Save data directly to Firestore without uploading image to Storage
      await _firestore.collection('recycling_requests').add(requestModel.toMap());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }
}
