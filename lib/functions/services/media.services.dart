import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/dto/delete_data_dto.dart';
import 'package:pix2life/dto/fetch_audio_response_dto.dart';
import 'package:pix2life/dto/fetch_gallery_dto.dart';
import 'package:pix2life/dto/fetch_image_response_dto.dart';
import 'package:pix2life/dto/fetch_video_response_dto.dart';
import 'package:pix2life/dto/update_audio_response_dto.dart';
import 'package:pix2life/dto/update_image_response_dto.dart';
import 'package:pix2life/dto/updated_video_response_dto.dart';
import 'package:pix2life/dto/upload_audio_response_dto.dart';
import 'package:pix2life/dto/upload_image_match_dto.dart';
import 'package:pix2life/dto/upload_image_response_dto.dart';
import 'package:pix2life/dto/upload_video_response_dto.dart';
import 'package:pix2life/functions/services/api.services.dart';

class MediaService {
  final storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  final log = logger(MediaService);

  Future<UploadImageResponse> uploadImage(
      FormData formData, String? galleryName) async {
    final url = '${AppConfig.baseUrl}/image/upload?galleryName=${galleryName}';
    final data = await apiService.uploadFile(formData, url);
    final response = UploadImageResponse.fromJson(data);
    return response;
  }

  Future<UploadImageResponse> uploadAvatar(FormData formData) async {
    const url = '${AppConfig.baseUrl}/image/upload/avatar';
    final data = await apiService.uploadFile(formData, url);
    final response = UploadImageResponse.fromJson(data);
    return response;
  }

  Future<UploadImageMatchResponse> matchImage(FormData formData) async {
    final url = '${AppConfig.baseUrl}/image/upload/match';
    final data = await apiService.uploadFile(formData, url);
    log.d(data);
    final response = UploadImageMatchResponse.fromJson(data);
    return response;
  }

  Future<List<Map<String, dynamic>>> fetchImages() async {
    const url = '${AppConfig.baseUrl}/image/user/all';
    final List<dynamic> imageList = await apiService.fetchData(url);
    return imageList.map((image) => image as Map<String, dynamic>).toList();
  }

  Future<UpdateImageResponse> updateImage(
      Map<String, dynamic> updateData, String imageId) async {
    final url = '${AppConfig.baseUrl}/image/update?imageId=${imageId}';
    final data = await apiService.updateData(updateData, url);
    final response = UpdateImageResponse.fromJson(data);
    return response;
  }

  Future<DeleteDataResponse> deleteImage(String imageId) async {
    final url = '${AppConfig.baseUrl}/image/destroy?imageId=${imageId}';
    final data = await apiService.deleteData(url);
    final response = DeleteDataResponse.fromJson(data);
    return response;
  }

  Future<UploadVideoResponse> uploadVideo(
      FormData formData, String? galleryName) async {
    final url = '${AppConfig.baseUrl}/video/upload?galleryName=${galleryName}';
    final data = await apiService.uploadFile(formData, url);
    final response = UploadVideoResponse.fromJson(data);
    return response;
  }

  Future<List<Map<String, dynamic>>> fetchVideos() async {
    const url = '${AppConfig.baseUrl}/video/user/all';
    final List<dynamic> imageList = await apiService.fetchData(url);
    return imageList.map((image) => image as Map<String, dynamic>).toList();
  }

  Future<UpdatedVideoResponse> updateVideo(
      Map<String, dynamic> updateData, String videoId) async {
    final url = '${AppConfig.baseUrl}/video/update?videoId=${videoId}';
    final data = await apiService.updateData(updateData, url);
    final response = UpdatedVideoResponse.fromJson(data);
    return response;
  }

  Future<DeleteDataResponse> deleteVideo(String videoId) async {
    final url = '${AppConfig.baseUrl}/video/destroy?videoId=${videoId}';
    final data = await apiService.deleteData(url);
    final response = DeleteDataResponse.fromJson(data);
    return response;
  }

  Future<UploadAudioResponse> uploadAudio(
      FormData formData, String? galleryName) async {
    final url = '${AppConfig.baseUrl}/audio/upload?galleryName=${galleryName}';
    final data = await apiService.uploadFile(formData, url);
    final response = UploadAudioResponse.fromJson(data);
    return response;
  }

  Future<List<Map<String, dynamic>>> fetchAudios() async {
    const url = '${AppConfig.baseUrl}/audio/user/all';
    final List<dynamic> imageList = await apiService.fetchData(url);
    return imageList.map((image) => image as Map<String, dynamic>).toList();
  }

  Future<UpdateAudioResponse> updateAudio(
      Map<String, dynamic> updateData, String audioId) async {
    final url = '${AppConfig.baseUrl}/audio/update?audioId=${audioId}';
    final data = await apiService.updateData(updateData, url);
    final response = UpdateAudioResponse.fromJson(data);
    return response;
  }

  Future<DeleteDataResponse> deleteAudio(String audioId) async {
    final url = '${AppConfig.baseUrl}/audio/destroy?audioId=${audioId}';
    final data = await apiService.deleteData(url);
    final response = DeleteDataResponse.fromJson(data);
    return response;
  }

  Future createGallery(FormData formData) async {
    const url = '${AppConfig.baseUrl}/gallery/create';
    final data = await apiService.uploadFile(formData, url);
    final response = data;
    return response;
  }

  Future<FetchGalleriesResponse> fetchGalleries() async {
    const url = '${AppConfig.baseUrl}/gallery/get';
    final data = await apiService.fetchData(url);
    return FetchGalleriesResponse.fromJson(data);
  }

  Future<FetchImagesResponse> fetchImagesByGallery(String galleryName) async {
    final url =
        '${AppConfig.baseUrl}/image/gallery/all?galleryName=${galleryName}';

    final data = await apiService.fetchData(url);
    return FetchImagesResponse.fromJson(data);
  }

  Future<FetchAudiosResponse> fetchAudiosByGallery(String galleryName) async {
    final url =
        '${AppConfig.baseUrl}/audio/gallery/all?galleryName=${galleryName}';
    final data = await apiService.fetchData(url);
    return FetchAudiosResponse.fromJson(data);
  }

  Future<FetchVideoResponse> fetchVideosGallery(String galleryName) async {
    final url =
        '${AppConfig.baseUrl}/video/gallery/all?galleryName=${galleryName}';
    final data = await apiService.fetchData(url);
    return FetchVideoResponse.fromJson(data);
  }
}
