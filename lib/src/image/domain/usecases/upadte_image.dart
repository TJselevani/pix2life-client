import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

class UpdateImageParams extends Equatable {
  final String imageId;
  final DataMap updateData;

  const UpdateImageParams({
    required this.imageId,
    required this.updateData,
  });

  UpdateImageParams.empty() : this(imageId: '_empty.imageId', updateData: {});

  @override
  List<Object?> get props => [imageId];
}

class UpdateImage implements UseCase<Image, UpdateImageParams> {
  final ImageRepository _imageRepository;
  const UpdateImage(this._imageRepository);
  @override
  ResultFuture<Image> call(params) async {
    return await _imageRepository.updateImage(
        updateData: params.updateData, imageId: params.imageId);
  }
}
