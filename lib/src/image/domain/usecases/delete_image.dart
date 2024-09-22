import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

class DeleteImageParams extends Equatable {
  final String imageId;

  DeleteImageParams({
    required this.imageId,
  });

  DeleteImageParams.empty() : this(imageId: '_empty.imageId');

  @override
  List<Object?> get props => [imageId];
}

class DeleteImage implements UseCase<String, DeleteImageParams> {
  final ImageRepository _imageRepository;
  const DeleteImage(this._imageRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _imageRepository.deleteImage(imageId: params.imageId);
  }
}
