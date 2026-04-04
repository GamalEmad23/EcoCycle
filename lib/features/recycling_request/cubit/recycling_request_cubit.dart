import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'recycling_request_state.dart';

class RecyclingRequestCubit extends Cubit<RecyclingRequestState> {
  RecyclingRequestCubit() : super(RecyclingRequestInitial());

  String selectedMaterial = 'بلاستيك';
  String? selectedCenter;
  String weight = '';
  File? image;

  final ImagePicker _picker = ImagePicker();

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
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(RecyclingRequestUpdated());
      }
    } catch (e) {
      emit(RecyclingRequestError('حدث خطأ أثناء اختيار الصورة'));
    }
  }

  Future<void> submitRequest() async {
    if (selectedCenter == null || weight.isEmpty || image == null) {
      emit(RecyclingRequestError('يرجى تعبئة جميع الحقول وإرفاق صورة'));
      return;
    }

    emit(RecyclingRequestLoading());

    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child('recycling_requests/$fileName');
      final UploadTask uploadTask = storageRef.putFile(image!);
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('recycling_requests').add({
        'material': selectedMaterial,
        'center': selectedCenter,
        'weight': double.tryParse(weight) ?? 0.0,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

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