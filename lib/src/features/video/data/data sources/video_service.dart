import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_video_response_dto.dart';
import 'package:pix2life/core/dtos/updated_video_response_dto.dart';
import 'package:pix2life/core/dtos/upload_video_response_dto.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';

class VideoService {
  final ApiService _apiService;
  VideoService(this._apiService);
  final log = createLogger(ApiService);

  Future<UploadVideoResponse> uploadVideo(
      FormData formData, String galleryName) async {
    final url = '${AppSecrets.baseUrl}/video/upload?galleryName=$galleryName';
    final data = await _apiService.uploadFile(formData, url);
    return UploadVideoResponse.fromJson(data);
  }

  Future<FetchVideoResponse> fetchVideos() async {
    const url = '${AppSecrets.baseUrl}/video/user/all';
    final data = await _apiService.fetchData(url);
    return FetchVideoResponse.fromJson(data);
  }

  Future<UpdatedVideoResponse> updateVideo(
      VideoModel video, DataMap updateData) async {
    final url = '${AppSecrets.baseUrl}/video/update?videoId=${video.id}';
    final data = await _apiService.updateData(updateData, url);
    return UpdatedVideoResponse.fromJson(data);
  }

  Future<DeleteDataResponse> deleteVideo(String videoId) async {
    final url = '${AppSecrets.baseUrl}/video/destroy?videoId=$videoId';
    final data = await _apiService.deleteData(url);
    return DeleteDataResponse.fromJson(data);
  }
}
