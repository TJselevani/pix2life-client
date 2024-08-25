

import 'package:pix2life/models/entities/gallery.model.dart';

class FetchGalleriesResponse {
  final String message;
  final List<Gallery> galleries;

  FetchGalleriesResponse({
    required this.message,
    required this.galleries,
  });

  factory FetchGalleriesResponse.fromJson(Map<String, dynamic> json) {
    var galleriesJson = json['gallery'] as List;
    List<Gallery> galleriesList = galleriesJson.map((gallery) => Gallery.fromJson(gallery)).toList();

    return FetchGalleriesResponse(
      message: json['message'],
      galleries: galleriesList,
    );
  }
}
