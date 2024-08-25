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
import 'package:pix2life/functions/video_player/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:pix2life/config/common/video_thumbnail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoGalleryPage extends StatefulWidget {
  const VideoGalleryPage({super.key});

  @override
  State<VideoGalleryPage> createState() => _VideoGalleryPageState();
}

class _VideoGalleryPageState extends State<VideoGalleryPage> {
  late Future<List<Map<String, dynamic>>> _videos;
  final MediaService mediaService = MediaService();
  VideoPlayerController? _controller;
  final log = logger(VideoGalleryPage);

  String _searchQuery = "";
  List<Map<String, dynamic>> _allVideos = [];
  List<Map<String, dynamic>> _filteredVideos = [];
  bool _isSearchVisible = false;
  String? _selectedVideoName = 'Video Gallery';
  String? _selectedVideoUrl;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    _videos = mediaService.fetchVideos();
    _videos.then((videos) {
      setState(() {
        _allVideos = videos;
        _filteredVideos = videos;
        if (videos.isNotEmpty) {
          final randomVideo = videos[Random().nextInt(videos.length)];
          _selectedVideoName = randomVideo['filename'];
          _selectedVideoUrl = randomVideo['url'];
          _initializeVideoPlayer(_selectedVideoUrl!);
        }
      });
    });
  }

  void _initializeVideoPlayer(String url) {
    _controller?.dispose();
    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller?.pause());
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  void _refreshVideos() {
    _loadVideos();
  }

  void _filterVideos(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredVideos = _allVideos;
      } else {
        _filteredVideos = _allVideos
            .where((video) =>
                video['filename'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showVideoInfo(Map<String, dynamic> video) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(video['filename']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('File Name: ${video['filename'] ?? 'Unknown'}'),
              Text('Description: ${video['description'] ?? 'No description'}'),
              Text('Gallery: ${video['galleryName'] ?? 'Media Gallery'}'),
              Text('Created: ${Utility.formatTimestamp(video['createdAt'])}'),
              Text('(${Utility.getRelativeTime(video['createdAt'])}) Ago'),
            ],
          ),
          actions: [
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
                          data: video,
                          type: 'video',
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
                  child: Text('Update'),
                ),
                SizedBox(width: 70.w),
                TextButton(
                  onPressed: () async {
                    try {
                      final videoId = video['id'];
                      final response = await mediaService.deleteVideo(videoId);
                      Navigator.of(context).pop(); // Close the dialog
                      SuccessSnackBar.show(
                          context: context,
                          message: response.message); // Display the snackbar
                      _refreshVideos(); // Refresh the videos list
                    } catch (e) {
                      Navigator.of(context)
                          .pop(); // Close the dialog in case of error as well
                      ErrorSnackBar.show(
                          context: context,
                          message: 'Failed to delete video: $e');
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppPalette.redColor1,
                    foregroundColor: AppPalette.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
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
            _selectedVideoName ?? 'Video Gallery',
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.refresh, size: 24.sp),
          onPressed: _refreshVideos,
        ),
        bottom: _isSearchVisible
            ? PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    onChanged: _filterVideos,
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
        future: _videos,
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
            return const Center(child: Text('No videos found'));
          } else {
            // Categorize videos by gallery name
            final galleryMap = <String, List<Map<String, dynamic>>>{};
            for (var video in snapshot.data!) {
              final galleryName = video['galleryName'] as String;
              if (!galleryMap.containsKey(galleryName)) {
                galleryMap[galleryName] = [];
              }
              galleryMap[galleryName]!.add(video);
            }

            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2.w, 2.h),
                        ),
                      ],
                    ),
                    child: _selectedVideoUrl != null &&
                            _controller != null &&
                            _controller!.value.isInitialized
                        ? Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  });
                                },
                                child: VideoPlayerWidget(
                                  controller: _controller!,
                                ),
                              ),
                              Positioned(
                                bottom: 8.h,
                                left: 8.w,
                                child: IconButton(
                                  icon: Icon(
                                    _controller!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: AppPalette.redColor1,
                                    size: 24.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_controller!.value.isPlaying) {
                                        _controller!.pause();
                                      } else {
                                        _controller!.play();
                                      }
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 8.h,
                                right: 8.w,
                                child: IconButton(
                                  icon: Icon(
                                    _controller!.value.volume > 0
                                        ? Icons.volume_up
                                        : Icons.volume_off,
                                    color: AppPalette.redColor1,
                                    size: 24.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_controller!.value.volume > 0) {
                                        _controller!.setVolume(0);
                                      } else {
                                        _controller!.setVolume(1);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: LoadingAnimationWidget.inkDrop(
                              color: AppPalette.redColor1,
                              size: 30.sp,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    padding: EdgeInsets.all(16.w),
                    children: galleryMap.entries.map((entry) {
                      final galleryName = entry.key;
                      final videos = entry.value;

                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, bottom: 10.h),
                              child: Text(
                                galleryName,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 150.h, // Adjust the height as needed
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 1.0,
                                ),
                                padding: EdgeInsets.all(16.w),
                                itemCount: videos.length,
                                itemBuilder: (context, index) {
                                  final video = videos[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedVideoName = video['filename'];
                                        _selectedVideoUrl = video['url'];
                                        _initializeVideoPlayer(
                                            _selectedVideoUrl!);
                                      });
                                    },
                                    onLongPress: () {
                                      _showVideoInfo(video);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(2.w, 2.h),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: VideoThumbnailWidget(
                                            videoUrl: video['url'],
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
