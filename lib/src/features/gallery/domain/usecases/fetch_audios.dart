import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';

class FetchAudiosByGalleryParams extends Equatable {
  final String galleryName;

  const FetchAudiosByGalleryParams({
    required this.galleryName,
  });

  const FetchAudiosByGalleryParams.empty()
      : this(galleryName: '_empty.galleryName');

  @override
  List<Object?> get props => [galleryName];
}

class FetchAudiosByGallery
    implements UseCase<List<Audio>, FetchAudiosByGalleryParams> {
  final GalleryRepository _galleryRepository;
  const FetchAudiosByGallery(this._galleryRepository);
  @override
  ResultFuture<List<Audio>> call(params) async {
    return await _galleryRepository.fetchAudiosByGallery(
        galleryName: params.galleryName);
  }
}
