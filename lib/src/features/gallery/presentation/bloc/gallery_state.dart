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

final class GalleryAudiosLoaded extends GalleryState {
  final List<Audio> audios;

  const GalleryAudiosLoaded({required this.audios});

  @override
  List<Object> get props => [audios];
}

final class GalleryCreated extends GalleryState {
  final String message;

  const GalleryCreated({required this.message});

  @override
  List<Object> get props => [message];
}

final class GalleryUpdated extends GalleryState {
  final String message;

  const GalleryUpdated({required this.message});

  @override
  List<Object> get props => [message];
}

final class GalleryDeleted extends GalleryState {
  final String message;

  const GalleryDeleted({required this.message});

  @override
  List<Object> get props => [message];
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
