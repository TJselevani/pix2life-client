// import 'package:flutter/material.dart';
// import 'package:pix2life/core/utils/theme/app_palette.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:convert';

// class QRCodeScreen extends StatelessWidget {
//   const QRCodeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Sample data
//     Map<String, dynamic> themeData = {
//       "brightness": "light",
//       "primaryColor": "#FF0000",
//       "indicatorColor": "#FF0000",
//       "scaffoldBackgroundColor": "#F5F5F5",
//       "fontFamily": "Poppins",
//       "appBarTheme": {
//         "backgroundColor": "#F5F5F5",
//         "titleTextStyle": {
//           "color": "#000000",
//           "fontSize": 20,
//           "fontWeight": "bold"
//         },
//         "iconTheme": {"color": "#000000"}
//       },
//       "textTheme": {
//         "bodyLarge": {"color": "#000000", "fontSize": 14},
//         "bodyMedium": {"color": "#000000", "fontSize": 16}
//       },
//       "inputDecorationTheme": {
//         "filled": true,
//         "fillColor": "#E0E0E0",
//         "enabledBorderColor": "#B0B0B0",
//         "focusedBorderColor": "#A0A0A0",
//         "errorBorderColor": "#FF0000"
//       },
//       "images": [
//         "https://example.com/image1.jpg",
//         "https://example.com/image2.jpg"
//       ],
//       "videos": [
//         "https://example.com/video1.mp4",
//         "https://example.com/video2.mp4"
//       ]
//     };

//     String jsonData = jsonEncode(themeData);

//     return Scaffold(
//       appBar: AppBar(title: const Text("QR Code")),
//       body: Center(
//         child: QrImageView(
//           data: jsonData,
//           version: QrVersions.auto,
//           size: 300.0,
//           backgroundColor: AppPalette.red.withOpacity(.4),
//         ),
//       ),
//     );
//   }
// }
