import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/image/data/models/image.model.dart';

class UpdateImageResponse {
  final String message;
  final ImageModel updatedImage;

  UpdateImageResponse({
    required this.message,
    required this.updatedImage,
  });

  factory UpdateImageResponse.fromJson(DataMap json) {
    final DataMap imageData = json['updatedImage'];
    final ImageModel image = ImageModel.fromJson(imageData);
    return UpdateImageResponse(
      message: json['message'],
      updatedImage: image,
    );
  }
}
