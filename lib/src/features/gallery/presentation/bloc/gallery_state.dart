part of 'gallery_bloc.dart';

sealed class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

final class GalleryInitial extends GalleryState {}

final class GalleryLoading extends GalleryState {}

final class GalleriesLoaded extends GalleryState {
  final List<Gallery> galleries;
  const GalleriesLoaded({required this.galleries});

  @override
  List<Object> get props => [galleries];
}

final class GalleryImagesLoaded extends GalleryState {
  final List<Photo> images;

  const GalleryImagesLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

final class GalleryVideosLoaded extends GalleryState {
  final List<Video> videos;

  const GalleryVideosLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

final class GalleryAudioLoaded extends GalleryState {
  final List<Audio> audios;

  const GalleryAudioLoaded({required this.audios});

  @override
  List<Object> get props => [audios];
}

final class GallerySuccess extends GalleryState {
  final String message;

  const GallerySuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class GalleryFailure extends GalleryState {
  final String message;

  const GalleryFailure({required this.message});

  @override
  List<Object> get props => [message];
}
