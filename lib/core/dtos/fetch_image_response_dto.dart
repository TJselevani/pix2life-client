import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';

class FetchImagesResponse {
  final List<ImageModel> images;

  FetchImagesResponse({required this.images});

  factory FetchImagesResponse.fromJson(DataMap json) {
    var imagesJson = json['images'] as List;
    List<ImageModel> imageList =
        imagesJson.map((image) => ImageModel.fromJson(image)).toList();

    return FetchImagesResponse(
      images: imageList,
    );
  }
}
