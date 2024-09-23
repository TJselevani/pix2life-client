import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/repositories/video_repository.dart';

class UploadVideoParams extends Equatable {
  final FormData formData;
  final String galleryName;

  const UploadVideoParams({
    required this.formData,
    required this.galleryName,
  });

  UploadVideoParams.empty()
      : this(formData: FormData.fromMap({}), galleryName: '_empty.galleryName');

  @override
  List<Object?> get props => [formData, galleryName];
}

class UploadVideo implements UseCase<String, UploadVideoParams> {
  final VideoRepository _videoRepository;
  const UploadVideo(this._videoRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _videoRepository.uploadVideo(
        formData: params.formData, galleryName: params.galleryName);
  }
}
