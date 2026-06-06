import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryUploadResult {
  final String imageUrl;
  final String publicId;

  const CloudinaryUploadResult({
    required this.imageUrl,
    required this.publicId,
  });
}

class CloudinaryService {
  static const String cloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME');
  static const String uploadPreset =
      String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET');

  bool get isConfigured => cloudName.isNotEmpty && uploadPreset.isNotEmpty;

  Future<CloudinaryUploadResult> uploadProductImage(XFile file) {
    return uploadImagePath(file.path, folder: 'products');
  }

  Future<CloudinaryUploadResult> uploadProfileImage(XFile file) {
    return uploadImagePath(file.path, folder: 'avatars');
  }

  Future<CloudinaryUploadResult> uploadImagePath(
    String path, {
    required String folder,
  }) async {
    if (!isConfigured) {
      throw Exception(
        'Cloudinary chua duoc cau hinh. Hay chay app voi '
        '--dart-define=CLOUDINARY_CLOUD_NAME=... va '
        '--dart-define=CLOUDINARY_UPLOAD_PRESET=...',
      );
    }

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = folder
      ..files.add(await http.MultipartFile.fromPath('file', path));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(json['error']?['message'] ?? 'Upload Cloudinary that bai');
    }

    return CloudinaryUploadResult(
      imageUrl: (json['secure_url'] ?? '').toString(),
      publicId: (json['public_id'] ?? '').toString(),
    );
  }
}
