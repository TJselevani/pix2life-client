import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

class UpdateImageParams extends Equatable {
  final Image image;

  const UpdateImageParams({
    required this.image,
  });

  UpdateImageParams.empty() : this(image: Image.empty());

  @override
  List<Object?> get props => [image];
}

class UpdateImage implements UseCase<Image, UpdateImageParams> {
  final ImageRepository _imageRepository;
  const UpdateImage(this._imageRepository);
  @override
  ResultFuture<Image> call(params) async {
    return await _imageRepository.updateImage(image: params.image);
  }
}
