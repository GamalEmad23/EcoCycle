import 'dart:io';
import 'package:eco_cycle/features/recycling_request/repository/recycling_request_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'recycling_request_state.dart';

class RecyclingRequestCubit extends Cubit<RecyclingRequestState> {
  final RecyclingRequestRepo _recyclingRepo;

  RecyclingRequestCubit(this._recyclingRepo) : super(RecyclingRequestInitial());

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
    if (selectedCenter == null || weight.isEmpty) {
      emit(RecyclingRequestError('يرجى تعبئة جميع الحقول المطلوبة'));
      return;
    }

    emit(RecyclingRequestLoading());

    try {
      await _recyclingRepo.submitRecyclingRequest(
        material: selectedMaterial,
        center: selectedCenter,
        weight: weight,
        image: image,
      );

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