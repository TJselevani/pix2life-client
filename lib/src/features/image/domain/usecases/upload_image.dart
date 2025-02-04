import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/domain/repositories/image_repository.dart';

class UploadImageParams extends Equatable {
  final String galleryName;
  final FormData formData;

  const UploadImageParams({
    required this.galleryName,
    required this.formData,
  });

  UploadImageParams.empty()
      : this(
          galleryName: '_empty.galleryName',
          formData: FormData.fromMap({}),
        );

  @override
  List<Object?> get props => [galleryName, formData];
}

class UploadImage implements UseCase<String, UploadImageParams> {
  final ImageRepository _imageRepository;
  const UploadImage(this._imageRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _imageRepository.uploadImage(
        formData: params.formData, galleryName: params.galleryName);
  }
}
