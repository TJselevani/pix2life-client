part of 'image_bloc.dart';

@immutable
sealed class ImageState extends Equatable {
  const ImageState();
  @override
  List<Object?> get props => [];
}

final class ImageInitial extends ImageState {}

final class ImageLoading extends ImageState {}

final class ImageSuccess extends ImageState {}

final class ImageFailure extends ImageState {}
