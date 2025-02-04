import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_image_response_dto.dart';
import 'package:pix2life/core/dtos/update_image_response_dto.dart';
import 'package:pix2life/core/dtos/upload_image_match_dto.dart';
import 'package:pix2life/core/dtos/upload_image_response_dto.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';

class ImageService {
  final ApiService _apiService;
  ImageService(this._apiService);

  Future<UploadImageResponse> uploadImage(
      FormData formData, String? galleryName) async {
    final url = '${AppSecrets.baseUrl}/image/upload?galleryName=$galleryName';
    final data = await _apiService.uploadFile(formData, url);
    return UploadImageResponse.fromJson(data);
  }

  Future<UploadImageResponse> uploadAvatar(FormData formData) async {
    const url = '${AppSecrets.baseUrl}/image/upload/avatar';
    final data = await _apiService.uploadFile(formData, url);
    return UploadImageResponse.fromJson(data);
  }

  Future<UploadImageMatchResponse> matchImage(FormData formData) async {
    const url = '${AppSecrets.baseUrl}/image/upload/match';
    final data = await _apiService.uploadFile(formData, url);
    return UploadImageMatchResponse.fromJson(data);
  }

  Future<FetchImagesResponse> fetchImages() async {
    const url = '${AppSecrets.baseUrl}/image/user/all';
    final data = await _apiService.fetchData(url);
    return FetchImagesResponse.fromJson(data);
  }

  Future<UpdateImageResponse> updateImage(
      ImageModel image, DataMap updateData) async {
    final url = '${AppSecrets.baseUrl}/image/update?imageId=${image.id}';
    final data = await _apiService.updateData(updateData, url);
    return UpdateImageResponse.fromJson(data);
  }

  Future<DeleteDataResponse> deleteImage(String imageId) async {
    final url = '${AppSecrets.baseUrl}/image/destroy?imageId=$imageId';
    final data = await _apiService.deleteData(url);
    return DeleteDataResponse.fromJson(data);
  }
}
