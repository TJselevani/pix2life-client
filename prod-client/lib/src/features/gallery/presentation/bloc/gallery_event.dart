part of 'gallery_bloc.dart';

@immutable
sealed class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

final class GalleryCreateEvent extends GalleryEvent {
  final FormData formData;

  const GalleryCreateEvent({required this.formData});

  @override
  List<Object> get props => [formData];
}

final class GalleryFetchGalleriesEvent extends GalleryEvent {}

final class GalleryFetchAudiosEvent extends GalleryEvent {
  final String galleryName;
  const GalleryFetchAudiosEvent({required this.galleryName});

  @override
  List<Object> get props => [galleryName];
}

final class GalleryFetchVideosEvent extends GalleryEvent {
  final String galleryName;
  const GalleryFetchVideosEvent({required this.galleryName});

  @override
  List<Object> get props => [galleryName];
}

final class GalleryFetchImagesEvent extends GalleryEvent {
  final String galleryName;
  const GalleryFetchImagesEvent({required this.galleryName});

  @override
  List<Object> get props => [galleryName];
}
