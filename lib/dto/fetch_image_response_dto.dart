import 'package:pix2life/models/entities/image.model.dart';

class FetchImagesResponse {
  final List<Image> images;

  FetchImagesResponse({required this.images});

  factory FetchImagesResponse.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List;
    List<Image> imageList =
        imagesJson.map((image) => Image.fromJson(image)).toList();

    return FetchImagesResponse(
      images: imageList,
    );
  }
}
