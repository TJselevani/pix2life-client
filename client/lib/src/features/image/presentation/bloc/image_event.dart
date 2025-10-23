part of 'image_bloc.dart';

@immutable
sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object?> get props => [];
}

final class ImageUploadEvent extends ImageEvent {
  final FormData formData;
  final String galleryName;

  const ImageUploadEvent({required this.formData, required this.galleryName});

  @override
  List<Object> get props => [formData, galleryName];
}

final class ImageMatchEvent extends ImageEvent {
  final FormData formData;

  const ImageMatchEvent({required this.formData});

  @override
  List<Object> get props => [formData];
}

final class ImageDeleteEvent extends ImageEvent {
  final String imageId;

  const ImageDeleteEvent({required this.imageId});

  @override
  List<Object> get props => [imageId];
}

final class ImageUpdateEvent extends ImageEvent {
  final Photo image;
  final DataMap updateData;

  const ImageUpdateEvent({required this.image, required this.updateData});

  @override
  List<Object> get props => [image, updateData];
}

// final class ImageFetchEvent extends ImageEvent {}

final class ImagesFetchEvent extends ImageEvent {}

final class ImageUploadAvatarEvent extends ImageEvent {
  final FormData formData;

  const ImageUploadAvatarEvent({required this.formData});

  @override
  List<Object> get props => [formData];
}
