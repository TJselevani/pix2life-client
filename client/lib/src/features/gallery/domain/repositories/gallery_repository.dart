import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';

abstract interface class GalleryRepository {
  const GalleryRepository();

  ResultFuture<String> createGallery({
    required FormData formData,
  });

  ResultFuture<List<Gallery>> fetchGalleries();

  ResultFuture<List<Photo>> fetchImagesByGallery({
    required String galleryName,
  });

  ResultFuture<List<Audio>> fetchAudiosByGallery({
    required String galleryName,
  });

  ResultFuture<List<Video>> fetchVideosByGallery({
    required String galleryName,
  });
}
