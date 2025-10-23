import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/create_gallery_dto.dart';
import 'package:pix2life/core/dtos/fetch_audio_response_dto.dart';
import 'package:pix2life/core/dtos/fetch_gallery_dto.dart';
import 'package:pix2life/core/dtos/fetch_image_response_dto.dart';
import 'package:pix2life/core/dtos/fetch_video_response_dto.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';

class GalleryService {
  final ApiService _apiService;
  GalleryService(this._apiService);
  final log = createLogger(GalleryService);

  Future<CreateGalleryResponse> createGallery(FormData formData) async {
    const url = '${AppSecrets.baseUrl}/gallery/create';
    final data = await _apiService.uploadFile(formData, url);
    return CreateGalleryResponse.fromJson(data);
  }

  Future<FetchGalleriesResponse> fetchGalleries() async {
    const url = '${AppSecrets.baseUrl}/gallery/get';
    final data = await _apiService.fetchData(url);
    return FetchGalleriesResponse.fromJson(data);
  }

  Future<FetchImagesResponse> fetchImagesByGallery(String galleryName) async {
    final url =
        '${AppSecrets.baseUrl}/image/gallery/all?galleryName=$galleryName';

    final data = await _apiService.fetchData(url);
    return FetchImagesResponse.fromJson(data);
  }

  Future<FetchAudiosResponse> fetchAudiosByGallery(String galleryName) async {
    final url =
        '${AppSecrets.baseUrl}/audio/gallery/all?galleryName=$galleryName';
    final data = await _apiService.fetchData(url);
    return FetchAudiosResponse.fromJson(data);
  }

  Future<FetchVideoResponse> fetchVideosByGallery(String galleryName) async {
    final url =
        '${AppSecrets.baseUrl}/video/gallery/all?galleryName=$galleryName';
    final data = await _apiService.fetchData(url);
    return FetchVideoResponse.fromJson(data);
  }
}
