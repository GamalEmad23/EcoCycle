import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_cycle/features/recycling_request/model/recycling_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

part 'recycling_request_state.dart';

class RecyclingRequestCubit extends Cubit<RecyclingRequestState> {
  RecyclingRequestCubit() : super(RecyclingRequestInitial()) {
    loadModel();
  }

  String predictionResult = '';
  double confidence = 0.0;
  bool isModelLoaded = false;
  Interpreter? _interpreter;
  List<String>? _labels;

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

  Future<void> loadModel() async {
    print("DEBUG: Loading model...");
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/ecocycle.tflite',
      );
      print(
        "DEBUG: Interpreter loaded. Input shape: ${_interpreter?.getInputTensor(0).shape}",
      );
      final labelData = await rootBundle.loadString('assets/model/labels.txt');
      _labels = labelData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      print("DEBUG: Labels loaded: $_labels");
      isModelLoaded = true;
    } catch (e) {
      print("DEBUG: Failed to load model: $e");
    }
  }

  Future<void> runModelOnImage(File file) async {
    if (!isModelLoaded || _interpreter == null || _labels == null) {
      print("Model not loaded or labels missing");
      return;
    }

    try {
      var inputTensor = _interpreter!.getInputTensor(0);
      var outputTensor = _interpreter!.getOutputTensor(0);

      print("Input type: ${inputTensor.type}");
      print("Output type: ${outputTensor.type}");

      var inputShape = inputTensor.shape;
      int height = inputShape[1];
      int width = inputShape[2];

      final imageBytes = await file.readAsBytes();
      img.Image? oriImage = img.decodeImage(imageBytes);

      if (oriImage == null) {
        print("Failed to decode image");
        return;
      }

      img.Image resizedImage = img.copyResize(
        oriImage,
        width: width,
        height: height,
        interpolation: img.Interpolation.linear,
      );

      bool isQuantized = inputTensor.type == TensorType.uint8;

      var bufferIndex = 0;

      // Use List type to ensure []= operator and reshape are available
      final List inputFlat = isQuantized
          ? Uint8List(height * width * 3)
          : Float32List(height * width * 3);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final pixel = resizedImage.getPixel(x, y);

          if (isQuantized) {
            // uint8 model
            inputFlat[bufferIndex++] = pixel.r.toInt();
            inputFlat[bufferIndex++] = pixel.g.toInt();
            inputFlat[bufferIndex++] = pixel.b.toInt();
          } else {
            // Raw pixel values (0-255) because the model has built-in TrueDivide and Subtract layers
            inputFlat[bufferIndex++] = pixel.r.toDouble();
            inputFlat[bufferIndex++] = pixel.g.toDouble();
            inputFlat[bufferIndex++] = pixel.b.toDouble();

          }
        }
      }

      var input = inputFlat.reshape([1, height, width, 3]);

      int numClasses = outputTensor.shape[1];

      var output = Float32List(numClasses).reshape([1, numClasses]);

      if (outputTensor.type == TensorType.uint8) {
        var outputUint8 = Uint8List(numClasses).reshape([1, numClasses]);

        _interpreter!.run(input, outputUint8);

        // 🔥 فك الـ quantization صح

        var scale = outputTensor.params.scale;
        var zeroPoint = outputTensor.params.zeroPoint;

        for (int i = 0; i < numClasses; i++) {
          output[0][i] = (outputUint8[0][i] - zeroPoint) * scale;
        }
      } else {
        _interpreter!.run(input, output);
      }

      print("Model Output Scores: ${output[0]}");

      // 🔥 اختيار أعلى قيمة

      double maxConfidence = -1;
      int maxIndex = -1;

      for (int i = 0; i < numClasses; i++) {
        if (output[0][i] > maxConfidence) {
          maxConfidence = output[0][i];
          maxIndex = i;
        }
      }

      if (maxIndex != -1) {
        String rawLabel = _labels![maxIndex].toLowerCase();
        String label = rawLabel.split(' ').last;

        print("Predicted Label: $label");
        print("Confidence: $maxConfidence");

        confidence = maxConfidence * 100;

        if (label.contains('paper')) {
          predictionResult = 'ورق';
          selectMaterial('ورق');
        } else if (label.contains('plastic')) {
          predictionResult = 'بلاستيك';
          selectMaterial('بلاستيك');
        } else if (label.contains('metal')) {
          predictionResult = 'معدن';
          selectMaterial('معدن');
        } else if (label.contains('electronics')) {
          predictionResult = 'إلكترونيات';
          selectMaterial('إلكترونيات');
        } else {
          predictionResult = label;
        }

        emit(RecyclingRequestUpdated());
      }
    } catch (e) {
      print("Inference error: $e");
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
        await runModelOnImage(image!);
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
      print("DEBUG: submitRequest - Current User: ${user?.uid}");

      if (user == null) {
        throw Exception(
          'User must be logged in to create a request (User is null)',
        );
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
        imageUrl: imageUrl, 
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

  @override
  Future<void> close() {
    _interpreter?.close();
    return super.close();
  }
}
