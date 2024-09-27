import 'package:pix2life/src/features/image/data/models/image.model.dart';

class FetchImagesResponse {
  final List<ImageModel> images;

  FetchImagesResponse({required this.images});

  factory FetchImagesResponse.fromJson(List json) {
    var imagesJson = json;
    List<ImageModel> imageList =
        imagesJson.map((image) => ImageModel.fromJson(image)).toList();

    return FetchImagesResponse(
      images: imageList,
    );
  }
}
