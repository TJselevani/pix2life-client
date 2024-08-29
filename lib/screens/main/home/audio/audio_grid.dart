import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:pix2life/functions/services/util.services.dart';
import 'package:pix2life/screens/main/update/edit_media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioGalleryPage extends StatefulWidget {
  const AudioGalleryPage({super.key});

  @override
  State<AudioGalleryPage> createState() => _AudioGalleryPageState();
}

class _AudioGalleryPageState extends State<AudioGalleryPage> {
  late Future<List<Map<String, dynamic>>> _audios;
  final MediaService mediaService = MediaService();
  final log = logger(AudioGalleryPage);
  AudioPlayer _audioPlayer = AudioPlayer();

  String _searchQuery = "";
  List<Map<String, dynamic>> _allAudios = [];
  List<Map<String, dynamic>> _filteredAudios = [];
  bool _isSearchVisible = false;
  String? _selectedAudioName = 'Audio Gallery';
  String? _selectedAudioUrl;
  bool _isPlaying = false;
  bool _isGridView = false; // Toggle for design

  @override
  void initState() {
    super.initState();
    _loadAudios();
  }

  Future<void> _loadAudios() async {
    _audios = mediaService.fetchAudios();
    _audios.then((audios) {
      setState(() {
        _allAudios = audios;
        _filteredAudios = audios;
        if (audios.isNotEmpty) {
          final randomAudio = audios[Random().nextInt(audios.length)];
          _selectedAudioName = randomAudio['filename'];
          _selectedAudioUrl = randomAudio['url'];
        }
      });
    });
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  void _refreshAudios() {
    _loadAudios();
  }

  void _filterAudios(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredAudios = _allAudios;
      } else {
        _filteredAudios = _allAudios
            .where((audio) =>
                audio['filename'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAudioInfo(Map<String, dynamic> audio) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  audio['filename'] ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text('File Name: ${audio['filename'] ?? 'Cactus'}'),
                Text(
                    'Description: ${audio['description'] ?? 'No description'}'),
                Text('Gallery: ${audio['galleryName'] ?? 'Media Gallery'}'),
                Text('Created: ${Utility.formatTimestamp(audio['createdAt'])}'),
                Text('(${Utility.getRelativeTime(audio['createdAt'])}) Ago'),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMediaScreen(
                              data: audio,
                              type: 'audio',
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppPalette.redColor,
                        foregroundColor: AppPalette.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Update'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          final audioId = audio['id'];
                          final response =
                              await mediaService.deleteAudio(audioId);
                          Navigator.of(context).pop(); // Close the dialog
                          SuccessSnackBar.show(
                              context: context,
                              message:
                                  response.message); // Display the snackbar
                          _refreshAudios(); // Refresh the audios list
                        } catch (e) {
                          Navigator.of(context)
                              .pop(); // Close the dialog in case of error as well
                          ErrorSnackBar.show(
                              context: context,
                              message: 'Failed to delete Audio: $e');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppPalette.redColor1,
                        foregroundColor: AppPalette.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      backgroundColor: AppPalette.whiteColor,
      appBar: AppBar(
        title: GestureDetector(
          onTap: _toggleSearchVisibility,
          child: Text(
            _selectedAudioName ?? 'Audio Gallery',
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              size: 24.sp,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
        bottom: _isSearchVisible
            ? PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    onChanged: _filterAudios,
                    decoration: InputDecoration(
                      hintText: 'Search by name',
                      prefixIcon: Icon(Icons.search, size: 24.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _audios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.waveDots(
                color: AppPalette.redColor1,
                size: 50.sp,
              ),
            );
          } else if (snapshot.hasError) {
            log.e('snapshot error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No audios found'));
          } else {
            // Categorize Audios by gallery name
            final galleryMap = <String, List<Map<String, dynamic>>>{};
            for (var audio in snapshot.data!) {
              final galleryName = audio['galleryName'] as String;
              if (!galleryMap.containsKey(galleryName)) {
                galleryMap[galleryName] = [];
              }
              galleryMap[galleryName]!.add(audio);
            }

            return _isGridView ? _buildGridView() : _buildListView();
          }
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _filteredAudios.length,
      itemBuilder: (context, index) {
        final audio = _filteredAudios[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAudioName = audio['filename'];
              _selectedAudioUrl = audio['url'];
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
                  color: AppPalette.redColor,
                  borderRadius: BorderRadius.circular(25.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isPlaying && _selectedAudioUrl == audio['url']
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
                              text: '${audio['filename']}',
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
              if (_isPlaying && _selectedAudioUrl == audio['url'])
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppPalette.whiteColor,
                    size: 20.sp,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  GridView _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.5,
      ),
      itemCount: _filteredAudios.length,
      itemBuilder: (context, index) {
        final audio = _filteredAudios[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAudioName = audio['filename'];
              _selectedAudioUrl = audio['url'];
              _playAudio(_selectedAudioUrl!);
            });
          },
          onLongPress: () {
            _showAudioInfo(audio);
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppPalette.redColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPlaying && _selectedAudioUrl == audio['url']
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 38.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Text(
                    audio['filename'],
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
