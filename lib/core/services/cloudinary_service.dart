import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  // ─── Replace these with your Cloudinary credentials ───────────────────────
  static const String _cloudName = 'dvyodhgd1';
  static const String _uploadPreset = 'eco_cycle_preset'; // unsigned preset
  // ──────────────────────────────────────────────────────────────────────────

  /// Uploads [imageFile] to Cloudinary and returns the secure URL.
  /// Throws an exception if the upload fails.
  static Future<String> uploadImage(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['folder'] = 'eco_cycle/profile_pictures'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['secure_url'] as String;
    } else {
      final error = json.decode(response.body);
      throw Exception(
        'Cloudinary upload failed: ${error['error']?['message'] ?? response.body}',
      );
    }
  }
}
