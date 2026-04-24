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

  Future<void> getAdminData(String userId) async {
    emit(AdminLoading());

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      print("USER ID: $userId");
      print("EXISTS: ${doc.exists}");
      print("DATA: ${doc.data()}");

      final data = doc.data();

      if (data == null) {
        final fallbackAdmin = AdminModel(
          name: "Admin",
          email: "",
          image: null,
        );

        emit(AdminSuccess(fallbackAdmin));
        return;
      }

      final admin = AdminModel(
        name: data['name'] ?? 'Admin',
        email: data['email'] ?? '',
        image: data['image'],
      );

      final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      final centersSnapshot =
      await FirebaseFirestore.instance.collection('centers').get();

      int totalOrders = 0;

      for (var user in usersSnapshot.docs) {
        final orders = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('recycling_requests')
            .get();

        totalOrders += orders.docs.length;
      }

      usersCount = usersSnapshot.docs.length;
      centersCount = centersSnapshot.docs.length;
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
        .doc(userId)
        .update({
      'image': imageUrl,
    });

    await getAdminData(userId);
  }
}