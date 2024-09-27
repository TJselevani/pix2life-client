import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';

class FetchImagesByGalleryParams extends Equatable {
  final String galleryName;

  const FetchImagesByGalleryParams({
    required this.galleryName,
  });

  const FetchImagesByGalleryParams.empty()
      : this(galleryName: '_empty.galleryName');

  @override
  List<Object?> get props => [galleryName];
}

class FetchImagesByGallery
    implements UseCase<List<Photo>, FetchImagesByGalleryParams> {
  final GalleryRepository _galleryRepository;
  const FetchImagesByGallery(this._galleryRepository);
  @override
  ResultFuture<List<Photo>> call(params) async {
    return await _galleryRepository.fetchImagesByGallery(
        galleryName: params.galleryName);
  }
}
