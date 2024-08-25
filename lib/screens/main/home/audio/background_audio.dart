// import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
//   final _player = AudioPlayer();

//   AudioPlayerHandler() {
//     _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
//     _player.currentIndexStream.map((index) => index ?? 0).pipe(queueIndex);
//     _player.positionStream.pipe(position);
//     _player.bufferedPositionStream.pipe(bufferedPosition);
//     _player.durationStream.pipe(mediaItem);
//   }

//   @override
//   Future<void> play() => _player.play();
//   @override
//   Future<void> pause() => _player.pause();
//   @override
//   Future<void> seek(Duration position) => _player.seek(position);
//   @override
//   Future<void> skipToNext() => _player.seekToNext();
//   @override
//   Future<void> skipToPrevious() => _player.seekToPrevious();

//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return playbackState.value!.copyWith(
//       controls: [
//         MediaControl.skipToPrevious,
//         _player.playing ? MediaControl.pause : MediaControl.play,
//         MediaControl.skipToNext,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActions: const [0, 1, 2],
//       playing: _player.playing,
//       processingState: {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,
//       updatePosition: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//       queueIndex: _player.currentIndex,
//     );
//   }
// }
