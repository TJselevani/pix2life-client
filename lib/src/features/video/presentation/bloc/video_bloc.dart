import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/domain/usecases/delete_video.dart';
import 'package:pix2life/src/features/video/domain/usecases/fetch_video.dart';
import 'package:pix2life/src/features/video/domain/usecases/update_video.dart';
import 'package:pix2life/src/features/video/domain/usecases/upload_video.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final DeleteVideo _deleteVideo;
  final FetchVideo _fetchVideo;
  final UpdateVideo _updateVideo;
  final UploadVideo _uploadVideo;

  VideoBloc({
    required DeleteVideo deleteVideo,
    required FetchVideo fetchVideo,
    required UpdateVideo updateVideo,
    required UploadVideo uploadVideo,
  })  : _deleteVideo = deleteVideo,
        _fetchVideo = fetchVideo,
        _updateVideo = updateVideo,
        _uploadVideo = uploadVideo,
        super(VideoInitial()) {
    on<VideoDeleteEvent>(_onVideoDeleteEvent);
    on<VideosFetchEvent>(_onVideosFetchEvent);
    on<VideoUpdateEvent>(_onVideoUpdateEvent);
    on<VideoUploadEvent>(_onVideoUploadEvent);
  }

  FutureOr<void> _onVideoDeleteEvent(
      VideoDeleteEvent event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    final response =
        await _deleteVideo(DeleteVideoParams(videoId: event.videoId));
    response.fold(
      (failure) => emit(VideoFailure(message: failure.errorMessage)),
      (videoId) => emit(VideoDeleted(
          videoId: videoId, message: 'Video deleted Successfully')),
    );
  }

  FutureOr<void> _onVideosFetchEvent(
      VideosFetchEvent event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    final response = await _fetchVideo();
    response.fold(
      (failure) => emit(VideoFailure(message: failure.errorMessage)),
      (videos) => emit(VideosLoaded(videos: videos)),
    );
  }

  FutureOr<void> _onVideoUpdateEvent(
      VideoUpdateEvent event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    final response = await _updateVideo(UpdateVideoParams(video: event.video, updateData: event.updateData));
    response.fold(
      (failure) => emit(VideoFailure(message: failure.errorMessage)),
      (videos) => emit(
          VideoUpdated(video: videos, message: 'Video updated successfully')),
    );
  }

  FutureOr<void> _onVideoUploadEvent(
      VideoUploadEvent event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    final response = await _uploadVideo(UploadVideoParams(
        formData: event.formData, galleryName: event.galleryName));
    response.fold(
      (failure) => emit(VideoFailure(message: failure.errorMessage)),
      (message) => emit(VideoSuccess(message: message)),
    );
  }
}
