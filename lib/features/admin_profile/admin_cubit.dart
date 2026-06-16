import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'model/admin_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  int usersCount = 0;
  int centersCount = 0;
  int ordersCount = 0;

  final String adminDocId = "gZadFjTDdLTzGWiSEWYQgmwVrkD2";

  Future<void> getAdminData(String userId) async {
    emit(AdminLoading());

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(adminDocId)
          .get();

      if (!doc.exists) {
        emit(AdminError("Admin document not found"));
        return;
      }

      final admin = AdminModel.fromFirestore(doc.data());

      final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      usersCount = usersSnapshot.docs.length;

      final centersSnapshot =
      await FirebaseFirestore.instance.collection('centers').get();

      centersCount = centersSnapshot.docs.length;

      int totalOrders = 0;

      for (var user in usersSnapshot.docs) {
        final orders = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('recycling_requests')
            .get();

        totalOrders += orders.docs.length;
      }

      ordersCount = totalOrders;

      emit(AdminSuccess(admin));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<String?> uploadImage(File file, String userId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("admins/$userId/profile.jpg");

      await ref.putFile(file);

      return await ref.getDownloadURL();
    } catch (e) {
      emit(AdminError(e.toString()));
      return null;
    }
  }

  Future<void> updateAdminImage(String userId, String imageUrl) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(adminDocId)
        .update({
      'image': imageUrl,
    });

    await getAdminData(userId);
  }
}