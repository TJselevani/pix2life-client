part of 'image_bloc.dart';

@immutable
sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object?> get props => [];
}

final class ImageUploadEvent extends ImageEvent {}

final class ImageMatchEvent extends ImageEvent {}

final class ImageDeleteEvent extends ImageEvent {}

final class ImageUpdateEvent extends ImageEvent {}

final class ImageFetchEvent extends ImageEvent {}

final class ImageUploadAvatarEvent extends ImageEvent {}
