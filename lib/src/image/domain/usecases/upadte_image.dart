import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

class DeleteImageParams extends Equatable {
  final String imageId;
  final DataMap updateData;

  DeleteImageParams({
    required this.imageId,
    required this.updateData, 
  });

  DeleteImageParams.empty() : this(imageId: '_empty.imageId', updateData: {});

  @override
  List<Object?> get props => [imageId];
}

class UpdateImage implements UseCase<Image, DeleteImageParams> {
  final ImageRepository _imageRepository;
  const UpdateImage(this._imageRepository);
  @override
  ResultFuture<Image> call(params) async {
    return await _imageRepository.updateImage(updateData: params.updateData, imageId: params.imageId);
  }
}
