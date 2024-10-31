import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:pix2life/src/features/audio/presentation/widgets/audio_popup_dialog.dart';

class AudioGridPage extends StatefulWidget {
  const AudioGridPage({super.key});

  @override
  State<AudioGridPage> createState() => _AudioGridPageState();
}

enum ViewMode { grid, list }

class _AudioGridPageState extends State<AudioGridPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _selectedAudioName = 'Audio Gallery';
  String? _selectedAudioUrl;
  bool _isPlaying = false;
  ViewMode _viewMode = ViewMode.list; // Use enum here
  late AnimationController _controller;
  bool isTapped = false;
  double targetValue = 0.8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          setState(() => isTapped = true);
        } else if (status == AnimationStatus.dismissed) {
          setState(() => isTapped = false);
        }
      });
    final currentState = context.read<AudioBloc>().state;

    if (currentState is! AudiosLoaded) {
      context.read<AudioBloc>().add(AudiosFetchEvent());
    }
  }

  void _showAudioInfo(Audio audio) {
    showDialog(
      context: context,
      builder: (context) {
        return AudioDialog(
          audio: audio,
          targetValue: targetValue,
          controller: _controller,
        );
      },
    );
  }

  void _playAudio(String url) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedAudioName,
          style: TextStyle(fontSize: 20.sp),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.refresh, size: 24.sp),
          onPressed: () {
            context.read<AudioBloc>().add(AudiosFetchEvent());
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _viewMode == ViewMode.grid ? Icons.grid_view : Icons.list,
              size: 24.sp,
            ),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == ViewMode.grid
                    ? ViewMode.list
                    : ViewMode.grid; // Toggle view mode
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<AudioBloc, AudioState>(listener: (context, state) {
        if (state is AudioFailure) {
          ErrorSnackBar.show(context: context, message: state.message);
        }

        if (state is AudioDeleted) {
          SuccessSnackBar.show(context: context, message: state.message);
        }

        if (state is AudioUpdated) {
          SuccessSnackBar.show(context: context, message: state.message);
        }
      }, builder: (context, state) {
        if (state is AudioFailure) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is AudioLoading) {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: AppPalette.red,
              size: 50.sp,
            ),
          );
        } else if (state is AudiosLoaded) {
          final audios = state.audios;

          if (audios.isEmpty) {
            return const Center(child: Text('No Audios found'));
          }

          return _viewMode == ViewMode.grid
              ? _buildGridView(audios)
              : _buildListView(audios);
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      }),
    );
  }

  ListView _buildListView(List<Audio> audios) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: audios.length,
      itemBuilder: (context, index) {
        final audio = audios[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAudioName = audio.filename;
              _selectedAudioUrl = audio.url;
              _playAudio(_selectedAudioUrl!);
            });
          },
          onLongPress: () {
            _showAudioInfo(audio);
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppPalette.red,
                  borderRadius: BorderRadius.circular(25.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isPlaying && _selectedAudioUrl == audio.url
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 48.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: audio.filename,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isPlaying && _selectedAudioUrl == audio.url)
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppPalette.primaryWhite,
                    size: 20.sp,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  GridView _buildGridView(List<Audio> audios) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.5,
      ),
      itemCount: audios.length,
      itemBuilder: (context, index) {
        final audio = audios[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAudioName = audio.filename;
              _selectedAudioUrl = audio.url;
              _playAudio(_selectedAudioUrl!);
            });
          },
          onLongPress: () {
            _showAudioInfo(audio);
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppPalette.red,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPlaying && _selectedAudioUrl == audio.url
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 38.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Text(
                    audio.filename,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
