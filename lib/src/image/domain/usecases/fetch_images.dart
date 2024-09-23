import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

class FetchImages implements UseCaseWithoutParams<List<Image>> {
  final ImageRepository _imageRepository;
  const FetchImages(this._imageRepository);
  @override
  ResultFuture<List<Image>> call() async {
    return await _imageRepository.fetchImages();
  }
}
