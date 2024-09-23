import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/audio/domain/entities/audio.dart';
import 'package:pix2life/src/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/video/domain/entities/video.dart';

abstract interface class GalleryRepository {
  const GalleryRepository();

  ResultFuture<String> createGallery({
    required FormData formData,
  });

  ResultFuture<List<Gallery>> fetchGalleries();

  ResultFuture<List<Image>> fetchImagesByGallery({
    required String galleryName,
  });

  ResultFuture<List<Audio>> fetchAudiosByGallery({
    required String galleryName,
  });

  ResultFuture<List<Video>> fetchVideosByGallery({
    required String galleryName,
  });
}
