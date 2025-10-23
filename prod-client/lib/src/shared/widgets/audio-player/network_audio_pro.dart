// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class AudioPlayerProWidget extends StatefulWidget {
//   final String audioUrl;

//   const AudioPlayerProWidget({super.key, required this.audioUrl});

//   @override
//   State<AudioPlayerProWidget> createState() => _AudioPlayerProWidgetState();
// }

// class _AudioPlayerProWidgetState extends State<AudioPlayerProWidget> {
//   late AudioPlayer _audioPlayer;
//   bool _isPlaying = false;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _audioPlayer.onDurationChanged.listen((duration) {
//       setState(() {
//         _duration = duration;
//       });
//     });
//     _audioPlayer.onPositionChanged.listen((position) {
//       setState(() {
//         _position = position;
//       });
//     });
//     _audioPlayer.onPlayerComplete.listen((_) {
//       setState(() {
//         _isPlaying = false;
//         _position = Duration.zero;
//       });
//     });
//   }

//   void _togglePlayPause() {
//     if (_isPlaying) {
//       _audioPlayer.pause();
//     } else {
//       _audioPlayer.play(UrlSource(widget.audioUrl));
//     }
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }

//   void _seekAudio(Duration position) {
//     _audioPlayer.seek(position);
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Slider(
//           value: _position.inSeconds.toDouble(),
//           max: _duration.inSeconds.toDouble(),
//           onChanged: (value) {
//             _seekAudio(Duration(seconds: value.toInt()));
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//               onPressed: _togglePlayPause,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
