import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:pix2life/src/shared/widgets/video-player/thumbnail/network_video_thumbnail_widget.dart';

class VideoGridPage extends StatefulWidget {
  const VideoGridPage({super.key});

  @override
  State<VideoGridPage> createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  String _selectedVideoName = 'video Gallery';
  // ignore: unused_field
  String? _selectedVideoUrl;

  @override
  void initState() {
    super.initState();
    // final currentState = context.read<VideoBloc>().state;
    context.read<VideoBloc>().add(VideosFetchEvent());

    // Trigger the event to fetch videos
    // if (currentState is! VideosLoaded) {
    //   context.read<VideoBloc>().add(VideosFetchEvent());
    // }
  }

  void _showVideoInfo(Video video) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(video.filename),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('File Name: ${video.filename}'),
              Text('Description: ${video.description}'),
              Text('Gallery: ${video.galleryName}'),
              Text('Created: ${video.createdAt}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: AppPalette.red,
                foregroundColor: AppPalette.primaryWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppPalette.primaryWhite,
      appBar: AppBar(
        title: Text(
          _selectedVideoName,
          style: TextStyle(fontSize: 20.sp),
        ),
        centerTitle: true,
        // backgroundColor: AppPalette.primaryWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.refresh, size: 24.sp),
          onPressed: () {
            context.read<VideoBloc>().add(VideosFetchEvent()); // Refresh videos
          },
        ),
      ),
      body: BlocConsumer<VideoBloc, VideoState>(
        listener: (context, state) {
          if (state is VideoFailure) {
            ErrorSnackBar.show(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is VideoFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is VideoLoading) {
            return Center(
              child: LoadingAnimationWidget.waveDots(
                color: AppPalette.red,
                size: 50.sp,
              ),
            );
          } else if (state is VideosLoaded) {
            final videos = state.videos;

            if (videos.isEmpty) {
              return const Center(child: Text('No Videos found'));
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three images per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0, // Square images
                ),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedVideoName = video.filename;
                        _selectedVideoUrl = video.url;
                      });
                    },
                    onLongPress: () {
                      _showVideoInfo(video);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(2.w, 2.h),
                          ),
                        ],
                      ),
                      child: VideoThumbnailWidget(
                        videoUrl: video.url,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
