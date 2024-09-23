part of 'image_bloc.dart';

@immutable
sealed class ImageState extends Equatable {
  const ImageState();
  @override
  List<Object?> get props => [];
}

final class ImageInitial extends ImageState {}

final class ImageLoading extends ImageState {}

final class ImagesLoaded extends ImageState {
  final List<Image> images;

  const ImagesLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

final class ImageLoaded extends ImageState {
  final Image image;

  const ImageLoaded({required this.image});

  @override
  List<Object> get props => [image];
}

final class ImageUpdated extends ImageState {
  final Image image;
  final String message;

  const ImageUpdated({required this.image, required this.message});

  @override
  List<Object> get props => [image];
}

final class ImageSuccess extends ImageState {
  final String message;

  const ImageSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class ImageFailure extends ImageState {
  final String message;

  const ImageFailure({required this.message});

  @override
  List<Object> get props => [message];
}
