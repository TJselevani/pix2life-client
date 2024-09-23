import 'package:pix2life/src/features/gallery/data/models/gallery.model.dart';

class FetchGalleriesResponse {
  final String message;
  final List<GalleryModel> galleries;

  FetchGalleriesResponse({
    required this.message,
    required this.galleries,
  });

  factory FetchGalleriesResponse.fromJson(Map<String, dynamic> json) {
    var galleriesJson = json['gallery'] as List;
    List<GalleryModel> galleriesList =
        galleriesJson.map((gallery) => GalleryModel.fromJson(gallery)).toList();

    return FetchGalleriesResponse(
      message: json['message'],
      galleries: galleriesList,
    );
  }
}
