// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:pix2life/config/app/app_palette.dart';
// import 'package:pix2life/config/common/normal_rounded_button.dart';
// import 'package:pix2life/config/logger/logger.dart';
// import 'package:pix2life/functions/notifications/error.dart';
// import 'package:pix2life/functions/notifications/success.dart';
// import 'package:pix2life/functions/services/media.services.dart';
// import 'package:pix2life/provider/auth_bloc.dart';
// import 'package:camera/camera.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pix2life/screens/navigation/main_navigation_page.dart';

// class UploadImageMatchPage extends StatefulWidget {
//   static Route(context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => MainPage()),
//     );
//   }

//   const UploadImageMatchPage({super.key});

//   @override
//   State<UploadImageMatchPage> createState() => _UploadImageMatchPageState();
// }

// class _UploadImageMatchPageState extends State<UploadImageMatchPage> {
//   final MediaService mediaService = MediaService();
//   final ImagePicker _picker = ImagePicker();
//   final log = logger(UploadImageMatchPage);
//   List<CameraDescription>? cameras;
//   bool _isLoading = false;
//   bool _isSet = false;
//   File? _imageFile;
//   String? _matchedImage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCameras();
//   }

//   Future<void> _initializeCameras() async {
//     try {
//       cameras = await availableCameras();
//       setState(() {
//         _isSet = true;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _pickImageFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _takePhoto() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _uploadMatchImage() async {
//     if (!mounted) return;
//     setState(() {
//       _matchedImage = null;
//       _isLoading = true;
//     });

//     File image = _imageFile!;
//     FormData formData = FormData.fromMap({
//       "image": await MultipartFile.fromFile(image.path,
//           filename: image.path.split('/').last),
//     });

//     try {
//       final response = await mediaService.matchImage(formData);
//       setState(() {
//         _matchedImage = response.image['url'];
//         SuccessSnackBar.show(context: context, message: response.message);
//         log.i('Successfully Matched Image: ${image.path.split('/').last}');
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         ErrorSnackBar.show(context: context, message: 'Match Failed');
//         log.e('Image Matching Failed ${image.path.split('/').last}: $e');
//       });
//     }

//     if (!mounted) return;
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authUser =
//         (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user;

//     return Scaffold(
//       backgroundColor: AppPalette.blackColor,
//       appBar: AppBar(
//         backgroundColor: AppPalette.transparent,
//         elevation: 0,
//         toolbarHeight: 64.h,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.w),
//         child: Column(
//           children: [
//             _buildHeader(),
//             SizedBox(height: 30.h),
//             _buildImageSelectionButtons(),
//             SizedBox(height: 30.h),
//             _buildInstructions(),
//             SizedBox(height: 40.h),
//             _buildImagePreviews(),
//             SizedBox(height: 30.h),
//             _buildActionButton(),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     final authUser =
//         (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user;

//     return Expanded(
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(37.w),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: 50.w,
//                 height: 5.h,
//                 color: AppPalette.blackColor,
//               ),
//               SizedBox(height: 20.h),
//               SizedBox(
//                 width: 247.w,
//                 child: RichText(
//                   text: TextSpan(
//                     text: authUser.email,
//                     style: TextStyle(
//                       color: AppPalette.fontTitleBlackColor2,
//                       fontFamily: 'Poppins',
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               GestureDetector(
//                 onTap: () => UploadImageMatchPage.Route(context),
//                 child: Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Proceed to Home'),
//                       SizedBox(width: 8.w),
//                       Icon(Icons.arrow_forward_ios),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 'Image Matching',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageSelectionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         GestureDetector(
//           onTap: _takePhoto,
//           child: _buildSelectionButton('Take Photo'),
//         ),
//         SizedBox(width: 20.w),
//         GestureDetector(
//           onTap: _pickImageFromGallery,
//           child: _buildSelectionButton('Search Gallery'),
//         ),
//       ],
//     );
//   }

//   Widget _buildSelectionButton(String text) {
//     return Container(
//       width: 120.w,
//       height: 120.h,
//       decoration: BoxDecoration(
//         color: AppPalette.redColor1,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'Poppins',
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   Widget _buildInstructions() {
//     return SizedBox(
//       width: 319.w,
//       child: RichText(
//         text: TextSpan(
//           text: 'Take a photo using your camera or pick an image from the gallery to match the image using our service.',
//           style: TextStyle(
//             color: AppPalette.greyColor0,
//             fontFamily: 'Poppins',
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _buildImagePreviews() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildImagePreview(
//           _imageFile,
//           'Your Image',
//         ),
//         SizedBox(width: 20.w),
//         _buildImagePreview(
//           _matchedImage != null ? CachedNetworkImage(imageUrl: _matchedImage!) : null,
//           _isLoading
//               ? LoadingAnimationWidget.beat(color: AppPalette.whiteColor, size: 50)
//               : 'Matched Image',
//         ),
//       ],
//     );
//   }

//   Widget _buildImagePreview(Widget? image, String placeholderText) {
//     return Container(
//       width: 150.w,
//       height: 150.h,
//       decoration: BoxDecoration(
//         color: AppPalette.redColor1,
//         shape: BoxShape.rectangle,
//       ),
//       child: image == null
//           ? Center(
//               child: Text(
//                 placeholderText,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'Poppins',
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             )
//           : image,
//     );
//   }

//   Widget _buildActionButton() {
//     return _isLoading
//         ? LoadingAnimationWidget.bouncingBall(
//             color: AppPalette.whiteColor,
//             size: 30.sp,
//           )
//         : RoundedButton(
//             name: "Match Image",
//             onPressed: _uploadMatchImage,
//           );
//   }
// }
