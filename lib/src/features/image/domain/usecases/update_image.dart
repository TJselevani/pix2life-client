import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/domain/repositories/image_repository.dart';

class UpdateImageParams extends Equatable {
  final Photo image;
  final DataMap updateData;

  const UpdateImageParams({
    required this.image,
    required this.updateData,
  });

  UpdateImageParams.empty() : this(image: Photo.empty(), updateData: {});

  @override
  List<Object?> get props => [image];
}

class UpdateImage implements UseCase<Photo, UpdateImageParams> {
  final ImageRepository _imageRepository;
  const UpdateImage(this._imageRepository);
  @override
  ResultFuture<Photo> call(params) async {
    return await _imageRepository.updateImage(image: params.image, updateData: params.updateData);
  }
}
