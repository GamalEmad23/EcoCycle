import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

part 'recycling_request_state.dart';

class RecyclingRequestCubit extends Cubit<RecyclingRequestState> {
  RecyclingRequestCubit() : super(RecyclingRequestInitial());

  String selectedMaterial = 'بلاستيك';
  String? selectedCenter;
  String weight = '';
  File? image;

  final ImagePicker _picker = ImagePicker();

  final String cloudName = "diwhgxyls";
  final String uploadPreset = "eco_cycle_upload";

  List<String> centers = [];
  bool isLoadingCenters = false;

  Future<void> getCenters() async {
    try {
      isLoadingCenters = true;
      emit(RecyclingRequestUpdated());

      final snapshot = await FirebaseFirestore.instance
          .collection('centers')
          .get();

      centers = snapshot.docs.map((doc) => doc['name'] as String).toList();

      isLoadingCenters = false;
      emit(RecyclingRequestUpdated());
    } catch (e) {
      isLoadingCenters = false;
      emit(RecyclingRequestError('Failed to load centers'));
    }
  }

  void selectMaterial(String material) {
    selectedMaterial = material;
    emit(RecyclingRequestUpdated());
  }

  void selectCenter(String? center) {
    selectedCenter = center;
    emit(RecyclingRequestUpdated());
  }

  void updateWeight(String newWeight) {
    weight = newWeight;
    emit(RecyclingRequestUpdated());
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(RecyclingRequestUpdated());
      }
    } catch (e) {
      emit(RecyclingRequestError('حدث خطأ أثناء اختيار الصورة'));
    }
  }

  Future<String?> uploadImageToCloudinary(File file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      final data = json.decode(responseData);

      return data['secure_url'];
    } catch (e) {
      print("Cloudinary error: $e");
      return null;
    }
  }

  Future<void> submitRequest() async {
    if (selectedCenter == null || weight.isEmpty) {
      emit(RecyclingRequestError('يرجى تعبئة جميع الحقول المطلوبة'));
      return;
    }

    emit(RecyclingRequestLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User must be logged in to create a request');
      }

      String? imageUrl;

      if (image != null) {
        imageUrl = await uploadImageToCloudinary(image!);
      }

      final model = RecyclingRequestModel(
        material: selectedMaterial,
        center: selectedCenter,
        weight: double.tryParse(weight) ?? 0.0,
        userId: user.uid,
        imageUrl: imageUrl, // 👈 الجديد
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recycling_requests')
          .add(model.toMap());

      selectedMaterial = 'بلاستيك';
      selectedCenter = null;
      weight = '';
      image = null;

      emit(RecyclingRequestSuccess());
    } catch (e) {
      emit(RecyclingRequestError('حدث خطأ أثناء تقديم الطلب: ${e.toString()}'));
    }
  }
}
