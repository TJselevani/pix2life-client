import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';

class FetchVideosByGalleryParams extends Equatable {
  final String galleryName;

  const FetchVideosByGalleryParams({
    required this.galleryName,
  });

  const FetchVideosByGalleryParams.empty()
      : this(galleryName: '_empty.galleryName');

  @override
  List<Object?> get props => [galleryName];
}

class FetchVideosByGallery
    implements UseCase<List<Video>, FetchVideosByGalleryParams> {
  final GalleryRepository _galleryRepository;
  const FetchVideosByGallery(this._galleryRepository);
  @override
  ResultFuture<List<Video>> call(params) async {
    return await _galleryRepository.fetchVideosByGallery(
        galleryName: params.galleryName);
  }
}
