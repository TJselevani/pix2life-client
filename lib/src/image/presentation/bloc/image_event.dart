part of 'image_bloc.dart';

@immutable
sealed class ImageEvent {}

final class ImageUploadEvent extends ImageEvent {}

final class ImageMatchEvent extends ImageEvent {}

final class ImageDeleteEvent extends ImageEvent {}

final class ImageUpdateEvent extends ImageEvent {}

final class ImageFetchEvent extends ImageEvent {}

final class ImageUploadAvatarEvent extends ImageEvent {}
