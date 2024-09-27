// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pix2life/core/utils/theme/app_palette.dart';

// class UploadScreen extends StatelessWidget {
//   const UploadScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppPalette.lightBackground,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 60),
//               _buildProfileSection(),
//               _buildOverviewSection(),
//               _buildActionCards(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection() {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: AppPalette.secondaryBlack.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 5,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(Icons.menu, size: 30, color: Colors.grey),
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                   'https://random.imagecdn.app/150/150', // Replace with actual profile image URL
//                 ),
//               ),
//               Icon(Icons.more_vert, size: 30, color: Colors.grey),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'tjselevani',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 5),
//           const Text(
//             'UX/UI Designer',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatColumn('Income', '\$8900'),
//               _buildStatColumn('Expenses', '\$5500'),
//               _buildStatColumn('Loan', '\$890'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatColumn(String label, String amount) {
//     return Column(
//       children: [
//         Text(
//           amount,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMediaPreviewSection() {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: AppPalette.secondaryBlack.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 5,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: const Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(Icons.menu, size: 30, color: Colors.grey),
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                   'https://random.imagecdn.app/150/150', // Replace with actual profile image URL
//                 ),
//               ),
//               Icon(Icons.more_vert, size: 30, color: Colors.grey),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewSection() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Wrap(
//             children: [
//               Text(
//                 'Upload Media',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(width: 10),
//               Icon(Icons.perm_media, color: Colors.grey),
//             ],
//           ),
//           Text('12 May 2024')
//         ],
//       ),
//     );
//   }

//   Widget _buildActionCards() {
//     return Column(
//       children: [
//         _buildActionCard(
//             CupertinoIcons.camera,
//             'Photographs, Pictures, Stills ',
//             'Upload Photos from your Gallery',
//             '\$150'),
//         _buildActionCard(
//             CupertinoIcons.video_camera,
//             'Clips, Recordings, Visuals',
//             'Upload Videos from your gallery',
//             '\$250'),
//         _buildActionCard(
//             CupertinoIcons.music_albums,
//             'Mp3s, Music, Sound Bites',
//             'Upload Audios from your gallery',
//             '\$400'),
//       ],
//     );
//   }

//   Widget _buildActionCard(
//       IconData icon, String title, String subtitle, String amount) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: AppPalette.secondaryBlack.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 5,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: AppPalette.red,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, size: 30, color: AppPalette.primaryWhite),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               amount,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
