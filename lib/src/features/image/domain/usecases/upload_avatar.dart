import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/domain/repositories/image_repository.dart';

class UploadAvatarParams extends Equatable {
  final FormData formData;

  const UploadAvatarParams({
    required this.formData,
  });

  UploadAvatarParams.empty() : this(formData: FormData.fromMap({}));

  @override
  List<Object?> get props => [formData];
}

class UploadAvatar implements UseCase<String, UploadAvatarParams> {
  final ImageRepository _imageRepository;
  const UploadAvatar(this._imageRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _imageRepository.uploadAvatar(formData: params.formData);
  }
}
