import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/utils/cache-manager/audio_cache_manager.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class AudioPlayerProCachedWidget extends StatefulWidget {
  final String audioUrl;
  final String audioName;

  const AudioPlayerProCachedWidget(
      {super.key, required this.audioUrl, required this.audioName});

  @override
  State<AudioPlayerProCachedWidget> createState() =>
      _AudioPlayerProCachedWidgetState();
}

class _AudioPlayerProCachedWidgetState
    extends State<AudioPlayerProCachedWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  File? _cachedAudio;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _cacheAudio();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _cacheAudio() async {
    try {
      final file = await AudioCacheManager().getSingleFile(widget.audioUrl);
      if (mounted) {
        setState(() {
          _cachedAudio = file;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error caching audio: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _togglePlayPause() async {
    if (_cachedAudio == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(_cachedAudio!.path));
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(minHeight: 50), // Prevent unbounded constraints
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: AppPalette.red,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Left side: Play button or loading animation
          _isPlaying
              ? GestureDetector(
                  onTap: _togglePlayPause,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: AppPalette.primaryWhite,
                      size: 30.sp,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.play_arrow, color: AppPalette.primaryWhite),
                  onPressed: _togglePlayPause,
                ),
          SizedBox(width: 10),

          // Middle: Audio Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Audio Name
                Text(
                  widget.audioName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.primaryWhite,
                  ),
                ),

                // Seek Bar Below Audio Name
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                  activeColor: AppPalette.primaryWhite,
                  inactiveColor: Colors.white38,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
