import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/create_gallery.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_audios.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_galleries.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_images.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_videos.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final CreateGallery _createGallery;
  final FetchGalleries _fetchGalleries;
  final FetchImagesByGallery _fetchImagesByGallery;
  final FetchAudiosByGallery _fetchAudiosByGallery;
  final FetchVideosByGallery _fetchVideosByGallery;

  GalleryBloc({
    required CreateGallery createGallery,
    required FetchGalleries fetchGalleries,
    required FetchImagesByGallery fetchImagesByGallery,
    required FetchAudiosByGallery fetchAudiosByGallery,
    required FetchVideosByGallery fetchVideosByGallery,
  })  : _createGallery = createGallery,
        _fetchGalleries = fetchGalleries,
        _fetchImagesByGallery = fetchImagesByGallery,
        _fetchAudiosByGallery = fetchAudiosByGallery,
        _fetchVideosByGallery = fetchVideosByGallery,
        super(GalleryInitial()) {
    on<GalleryCreateEvent>(_onGalleryCreateEvent);
    on<GalleryFetchGalleriesEvent>(_onGalleryFetchGalleriesEvent);
    on<GalleryFetchAudiosEvent>(_onGalleryFetchAudiosEvent);
    on<GalleryFetchImagesEvent>(_onGalleryFetchImagesEvent);
    on<GalleryFetchVideosEvent>(_onGalleryFetchVideosEvent);
  }

  FutureOr<void> _onGalleryCreateEvent(
      GalleryCreateEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final response =
        await _createGallery(CreateGalleryParams(formData: event.formData));
    response.fold(
      (failure) => emit(GalleryFailure(message: failure.errorMessage)),
      (message) => emit(GalleryCreated(message: message)),
    );
  }

  FutureOr<void> _onGalleryFetchGalleriesEvent(
      GalleryFetchGalleriesEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final response = await _fetchGalleries();
    response.fold(
      (failure) => emit(GalleryFailure(message: failure.errorMessage)),
      (galleries) => emit(GalleriesLoaded(galleries: galleries)),
    );
  }

  FutureOr<void> _onGalleryFetchAudiosEvent(
      GalleryFetchAudiosEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final response = await _fetchAudiosByGallery(
        FetchAudiosByGalleryParams(galleryName: event.galleryName));
    response.fold(
      (failure) => emit(GalleryFailure(message: failure.errorMessage)),
      (audios) => emit(GalleryAudiosLoaded(audios: audios)),
    );
  }

  FutureOr<void> _onGalleryFetchImagesEvent(
      GalleryFetchImagesEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final response = await _fetchImagesByGallery(
        FetchImagesByGalleryParams(galleryName: event.galleryName));
    response.fold(
      (failure) => emit(GalleryFailure(message: failure.errorMessage)),
      (images) => emit(GalleryImagesLoaded(images: images)),
    );
  }

  FutureOr<void> _onGalleryFetchVideosEvent(
      GalleryFetchVideosEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final response = await _fetchVideosByGallery(
        FetchVideosByGalleryParams(galleryName: event.galleryName));
    response.fold(
      (failure) => emit(GalleryFailure(message: failure.errorMessage)),
      (videos) => emit(GalleryVideosLoaded(videos: videos)),
    );
  }
}
