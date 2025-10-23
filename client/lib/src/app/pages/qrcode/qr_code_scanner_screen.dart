// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'dart:convert';

// class QRCodeScannerScreen extends StatefulWidget {
//   const QRCodeScannerScreen({super.key});

//   @override
//   State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
// }

// class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   Map<String, dynamic>? scannedData;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() async {
//     super.reassemble();

//     if (Platform.isAndroid) {
//       await controller!.pauseCamera();
//     }

//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Scan QR Code")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//               flex: 5,
//               child: QRView(
//                 key: qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//                 overlay: QrScannerOverlayShape(
//                   borderWidth: 10,
//                   borderLength: 20,
//                   borderRadius: 10,
//                   borderColor: Theme.of(context).primaryColor,
//                   cutOutSize: MediaQuery.of(context).size.width * 0.8,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Center(
//                 child: (scannedData != null)
//                     ? Text("Scanned Theme: ${scannedData!['theme']}")
//                     : const Text('Scan a code'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() => this.controller = controller);
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         scannedData = jsonDecode(scanData.code!);
//         _applyTheme(scannedData!); // Apply the scanned theme and data
//       });
//     });
//   }

//   void _applyTheme(Map<String, dynamic> data) {
//     // Logic to update theme, colors, images, and videos in your app
//   }
// }
