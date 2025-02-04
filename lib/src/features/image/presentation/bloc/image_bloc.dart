import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/domain/usecases/delete_image.dart';
import 'package:pix2life/src/features/image/domain/usecases/fetch_images.dart';
import 'package:pix2life/src/features/image/domain/usecases/match_image.dart';
import 'package:pix2life/src/features/image/domain/usecases/update_image.dart';
import 'package:pix2life/src/features/image/domain/usecases/upload_avatar.dart';
import 'package:pix2life/src/features/image/domain/usecases/upload_image.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final DeleteImage _deleteImage;
  final FetchImages _fetchImages;
  final MatchImage _matchImage;
  final UpdateImage _updateImage;
  final UploadImage _uploadImage;
  final UploadAvatar _uploadAvatar;

  ImageBloc({
    required DeleteImage deleteImage,
    required FetchImages fetchImages,
    required MatchImage matchImage,
    required UpdateImage updateImage,
    required UploadImage uploadImage,
    required UploadAvatar uploadAvatar,
  })  : _deleteImage = deleteImage,
        _fetchImages = fetchImages,
        _matchImage = matchImage,
        _updateImage = updateImage,
        _uploadImage = uploadImage,
        _uploadAvatar = uploadAvatar,
        super(ImageInitial()) {
    on<ImageDeleteEvent>(_onImageDeleteEvent);
    on<ImagesFetchEvent>(_onImagesFetchEvent);
    on<ImageMatchEvent>(_onImageMatchEvent);
    on<ImageUpdateEvent>(_onImageUpdateEvent);
    on<ImageUploadEvent>(_onImageUploadEvent);
    on<ImageUploadAvatarEvent>(_onImageUploadAvatarEvent);
  }

  FutureOr<void> _onImageDeleteEvent(
      ImageDeleteEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    final response =
        await _deleteImage(DeleteImageParams(imageId: event.imageId));
    response.fold(
      (failure) => emit(ImageFailure(message: failure.errorMessage)),
      (imageId) => emit(ImageDeleted(
          imageId: imageId, message: 'Image Deleted Successfully')),
    );
  }

  FutureOr<void> _onImagesFetchEvent(
      ImagesFetchEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    final response = await _fetchImages();
    response.fold(
      (failure) => emit(ImageFailure(message: failure.errorMessage)),
      (images) => emit(ImagesLoaded(images: images)),
    );
  }

  FutureOr<void> _onImageMatchEvent(
      ImageMatchEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    final response =
        await _matchImage(MatchImageParams(formData: event.formData));
    response.fold(
      (failure) => emit(ImageFailure(message: failure.errorMessage)),
      (image) => emit(ImageLoaded(image: image)),
    );
  }

  FutureOr<void> _onImageUpdateEvent(
      ImageUpdateEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    final response = await _updateImage(
        UpdateImageParams(image: event.image, updateData: event.updateData));
    response.fold(
      (failure) => emit(ImageFailure(message: failure.errorMessage)),
      (image) => emit(
          ImageUpdated(image: image, message: 'Image Updated successfully')),
    );
  }

  FutureOr<void> _onImageUploadEvent(
      ImageUploadEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    final response = await _uploadImage(UploadImageParams(
        galleryName: event.galleryName, formData: event.formData));
    response.fold(
      (failure) => emit(ImageFailure(message: failure.errorMessage)),
      (message) => emit(ImageSuccess(message: message)),
    );
  }

  FutureOr<void> _onImageUploadAvatarEvent(
      ImageUploadAvatarEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    final response =
        await _uploadAvatar(UploadAvatarParams(formData: event.formData));
    response.fold(
      (failure) => emit(ImageFailure(message: failure.errorMessage)),
      (message) => emit(ImageSuccess(message: message)),
    );
  }
}
