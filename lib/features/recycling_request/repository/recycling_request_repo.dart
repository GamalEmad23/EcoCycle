import 'dart:io';
import 'package:eco_cycle/core/services/recycling_firebase_service.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecyclingRequestRepo {
  final RecyclingFirebaseService _firebaseService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RecyclingRequestRepo({RecyclingFirebaseService? firebaseService})
    : _firebaseService = firebaseService ?? RecyclingFirebaseService();

  Future<void> submitRecyclingRequest({
    required String material,
    required String? center,
    required String weight,
    File? image, // Make image optional, it is no longer required
  }) async {
    final user = _auth.currentUser;
    final model = RecyclingRequestModel(
      material: material,
      center: center,
      weight: double.tryParse(weight) ?? 0.0,
      userId: user?.uid,
    );

    await _firebaseService.uploadRecyclingRequest(requestModel: model);
  }
}
