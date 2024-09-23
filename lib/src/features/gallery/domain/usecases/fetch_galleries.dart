import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';

class FetchGalleries implements UseCaseWithoutParams<List<Gallery>> {
  final GalleryRepository _galleryRepository;
  const FetchGalleries(this._galleryRepository);
  @override
  ResultFuture<List<Gallery>> call() async {
    return await _galleryRepository.fetchGalleries();
  }
}
