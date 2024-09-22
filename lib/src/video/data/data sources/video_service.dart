import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_video_response_dto.dart';
import 'package:pix2life/core/dtos/updated_video_response_dto.dart';
import 'package:pix2life/core/dtos/upload_video_response_dto.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/src/video/data/models/video.model.dart';

class VideoService {
  late ApiService _apiService;
  VideoService(this._apiService);
  final log = createLogger(ApiService);

  Future<UploadVideoResponse> uploadVideo(
      FormData formData, String galleryName) async {
    final url = '${AppSecrets.baseUrl}/video/upload?galleryName=${galleryName}';
    final data = await _apiService.uploadFile(formData, url);
    return UploadVideoResponse.fromJson(data);
  }

  Future<FetchVideoResponse> fetchVideos() async {
    const url = '${AppSecrets.baseUrl}/video/user/all';
    final DataMap imageList = await _apiService.fetchData(url);
    return FetchVideoResponse.fromJson(imageList);
  }

  Future<UpdatedVideoResponse> updateVideo(
      VideoModel updateData, String videoId) async {
    final url = '${AppSecrets.baseUrl}/video/update?videoId=${videoId}';
    final data = await _apiService.updateData(updateData, url);
    return UpdatedVideoResponse.fromJson(data);
  }

  Future<DeleteDataResponse> deleteVideo(String videoId) async {
    final url = '${AppSecrets.baseUrl}/video/destroy?videoId=${videoId}';
    final data = await _apiService.deleteData(url);
    return DeleteDataResponse.fromJson(data);
  }
}
