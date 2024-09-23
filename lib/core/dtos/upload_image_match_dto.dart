import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';

class UploadImageMatchResponse {
  final String message;
  final ImageModel image;

  UploadImageMatchResponse({
    required this.message,
    required this.image,
  });

  factory UploadImageMatchResponse.fromJson(Map<String, dynamic> json) {
    final DataMap img = json['image'];
    final ImageModel matchedImage = ImageModel.fromJson(img);
    return UploadImageMatchResponse(
        message: json['message'], image: matchedImage);
  }
}
