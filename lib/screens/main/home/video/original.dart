// import 'package:flutter/material.dart';
// import 'package:pix2life/config/app/app_palette.dart';
// import 'package:pix2life/config/logger/logger.dart';
// import 'package:pix2life/functions/services/media.services.dart';
// import 'dart:math';
// import 'package:pix2life/functions/video_player/video_player_widget.dart';
// import 'package:video_player/video_player.dart';

// class VideoGalleryPage extends StatefulWidget {
//   const VideoGalleryPage({super.key});

//   @override
//   State<VideoGalleryPage> createState() => _VideoGalleryPageState();
// }

// class _VideoGalleryPageState extends State<VideoGalleryPage> {
//   late Future<List<Map<String, dynamic>>> _videos;
//   final MediaService mediaService = MediaService();
//   VideoPlayerController? _controller;
//   final log = logger(VideoGalleryPage);

//   // ignore: unused_field
//   String _searchQuery = "";
//   List<Map<String, dynamic>> _allVideos = [];
//   List<Map<String, dynamic>> _filteredVideos = [];
//   bool _isSearchVisible = false;
//   String? _selectedVideoName = 'Video Gallery';
//   String? _selectedVideoUrl;

//   @override
//   void initState() {
//     super.initState();
//     _videos = mediaService.fetchVideos();
//     _videos.then((videos) {
//       setState(() {
//         _allVideos = videos;
//         _filteredVideos = videos;
//         if (videos.isNotEmpty) {
//           final randomVideo = videos[Random().nextInt(videos.length)];
//           _selectedVideoName = randomVideo['filename'];
//           _selectedVideoUrl = randomVideo['url'];
//           _initializeVideoPlayer(_selectedVideoUrl!);
//         }
//       });
//     });
//   }

//   void _initializeVideoPlayer(String url) {
//     _controller?.dispose();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(url))
//       ..addListener(() => setState(() {}))
//       ..setLooping(true)
//       ..initialize().then((_) => _controller?.play());
//   }

//   void _toggleSearchVisibility() {
//     setState(() {
//       _isSearchVisible = !_isSearchVisible;
//     });
//   }

//   void _refreshVideos() {
//     setState(() {
//       _videos = mediaService.fetchVideos();
//       _videos.then((videos) {
//         setState(() {
//           _allVideos = videos;
//           _filteredVideos = videos;
//           _searchQuery = "";
//           if (videos.isNotEmpty) {
//             final randomVideo = videos[Random().nextInt(videos.length)];
//             _selectedVideoName = randomVideo['filename'];
//             _selectedVideoUrl = randomVideo['url'];
//             _initializeVideoPlayer(_selectedVideoUrl!);
//           }
//         });
//       });
//     });
//   }

//   void _navigateToUploadPage() {
//     // Navigator.pushReplacementNamed(context, '/Home');
//     SnackBar(content: Text('Will implement Descriptions soon'));
//   }

//   void _filterVideos(String query) {
//     setState(() {
//       _searchQuery = query;
//       if (query.isEmpty) {
//         _filteredVideos = _allVideos;
//       } else {
//         _filteredVideos = _allVideos
//             .where((video) =>
//                 video['filename'].toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   void _showVideoInfo(Map<String, dynamic> video) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(video['filename']),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('File Name: ${video['filename'] ?? 'Cactus'}'),
//               Text('Description: ${video['description'] ?? 'No description'}'),
//               Text('URL: ${video['url']}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppPalette.whiteColor,
//       appBar: AppBar(
//         title: GestureDetector(
//           onTap: _toggleSearchVisibility,
//           child: _selectedVideoName!.isNotEmpty
//               ? Text('$_selectedVideoName')
//               : const Text('Image Gallery'),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.refresh),
//           onPressed: _refreshVideos,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.upload_file),
//             onPressed: _navigateToUploadPage,
//           ),
//         ],
//         bottom: _isSearchVisible
//             ? PreferredSize(
//                 preferredSize: const Size.fromHeight(kToolbarHeight),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: TextField(
//                     onChanged: _filterVideos,
//                     decoration: InputDecoration(
//                       hintText: 'Search by name',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : null,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _videos,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             log.e('snapshot error: ${snapshot.error}');
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No videos found'));
//           } else {
//             return Column(
//               children: [
//                 Expanded(
//                   flex: 4,
//                   child: Container(
//                     margin: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 2,
//                           blurRadius: 4,
//                           offset: const Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                     child: _selectedVideoUrl != null &&
//                             _controller!.value.isInitialized
//                         ? Stack(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     if (_controller!.value.isPlaying) {
//                                       _controller!.pause();
//                                     } else {
//                                       _controller!.play();
//                                     }
//                                   });
//                                 },
//                                 child: VideoPlayerWidget(
//                                   controller: _controller!,
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 8,
//                                 left: 8,
//                                 child: IconButton(
//                                   icon: Icon(
//                                     _controller!.value.isPlaying
//                                         ? Icons.pause
//                                         : Icons.play_arrow,
//                                     color: AppPalette.redColor1,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       if (_controller!.value.isPlaying) {
//                                         _controller!.pause();
//                                       } else {
//                                         _controller!.play();
//                                       }
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 8,
//                                 right: 8,
//                                 child: IconButton(
//                                   icon: Icon(
//                                     _controller!.value.volume > 0
//                                         ? Icons.volume_up
//                                         : Icons.volume_off,
//                                     color: AppPalette.redColor1,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       if (_controller!.value.volume > 0) {
//                                         _controller!.setVolume(0);
//                                       } else {
//                                         _controller!.setVolume(1);
//                                       }
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Stack(
//                             children: [
//                               Image.network(
//                                 'https://th.bing.com/th/id/OIF.FElOFIaYAfKg7YxKh8X1Bg?rs=1&pid=ImgDetMain',
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                               Center(child: CircularProgressIndicator()),
//                             ],
//                           ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: GridView.builder(
//                     scrollDirection: Axis.horizontal,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 1,
//                       crossAxisSpacing: 16.0,
//                       mainAxisSpacing: 16.0,
//                       childAspectRatio: 1.0,
//                     ),
//                     padding: const EdgeInsets.all(16.0),
//                     itemCount: _filteredVideos.length,
//                     itemBuilder: (context, index) {
//                       final video = _filteredVideos[index];
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedVideoName = video['filename'];
//                             _selectedVideoUrl = video['url'];
//                             _initializeVideoPlayer(_selectedVideoUrl!);
//                           });
//                         },
//                         onLongPress: () {
//                           _showVideoInfo(video);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 spreadRadius: 2,
//                                 blurRadius: 4,
//                                 offset: const Offset(2, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Expanded(
//                                 child: Image.network(
//                                   'https://th.bing.com/th/id/OIF.FElOFIaYAfKg7YxKh8X1Bg?rs=1&pid=ImgDetMain',
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
