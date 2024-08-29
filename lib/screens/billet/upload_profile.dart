import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/config/common/all_images.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:pix2life/models/entities/user.model.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/screens/billet/guide.dart';

class UploadProfilePicPage extends StatefulWidget {
  static Route(context) {
    Navigator.pushReplacementNamed(context, '/Home');
  }

  static Guide(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GuidePage()),
    );
  }

  const UploadProfilePicPage({super.key});

  @override
  State<UploadProfilePicPage> createState() => _UploadProfilePicPageState();
}

class _UploadProfilePicPageState extends State<UploadProfilePicPage> {
  final MediaService mediaService = MediaService();
  final ImagePicker _picker = ImagePicker();
  final log = logger(UploadProfilePicPage);
  bool _isLoading = false;
  bool _isSet = false;
  bool _isPending = false;
  bool _isUploaded = false;
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _isSet = true;
        _isPending = true;
        _isUploaded = false;
        _image = selectedImage;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    XFile image = _image!;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: image.name),
    });

    try {
      final response = await mediaService.uploadAvatar(formData);

      if (!mounted) return;

      setState(() {
        context.read<AuthBloc>().add(UserUpdatedEvent());
        SuccessSnackBar.show(context: context, message: response.message);
        log.i('Successfully uploaded Avatar Image: ${image.name}');
        _isPending = false;
        _isUploaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        ErrorSnackBar.show(context: context, message: 'Avatar Upload Failed');
        log.e('Upload failed for Avatar ${image.name}: $e');
      });
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isPending = false;
      _isSet = false;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User authUser =
        (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user;

    return Scaffold(
      backgroundColor: AppPalette.blackColor,
      appBar: AppBar(
        backgroundColor: AppPalette.transparent,
        elevation: 0,
        toolbarHeight: 64.h,
      ),
      body: Container(
        decoration: _buildBackgroundDecoration(),
        padding: EdgeInsets.all(18.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(authUser),
              _buildProfileImage(authUser),
              SizedBox(height: 40.h),
              _buildChooseImageButton(),
              if (_isPending) _buildUploadIcon(),
              SizedBox(height: 20.h),
              _buildInstructions(),
              SizedBox(height: 20.h),
              _buildProceedButton(),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      color: AppPalette.whiteColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(37.r),
        topRight: Radius.circular(37.r),
        bottomLeft: Radius.circular(37.r),
        bottomRight: Radius.circular(37.r),
      ),
      gradient: LinearGradient(
        colors: [AppPalette.whiteColor, AppPalette.whiteColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildHeader(User authUser) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(37.w),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              width: 50.w,
              height: 5.h,
              color: AppPalette.blackColor,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              // width: 247.w,
              child: RichText(
                text: TextSpan(
                  text: authUser.email,
                  style: TextStyle(
                    color: AppPalette.fontTitleBlackColor2,
                    fontFamily: 'Poppins',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(User authUser) {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.h),
        height: 200.h,
        width: 200.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          color: AppPalette.whiteColor,
        ),
        child: CircleAvatar(
          backgroundImage: _isSet
              ? FileImage(File(_image!.path))
              : NetworkImage(
                  authUser.avatarUrl.isNotEmpty
                      ? authUser.avatarUrl
                      : AppConfig.avatarUrl,
                ),
        ),
      ),
    );
  }

  Widget _buildChooseImageButton() {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: HoverButton(
          name: 'Choose Image',
          onPressed: _pickImage,
        ),
      ),
    );
  }

  Widget _buildUploadIcon() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 45.h),
      child: Center(
        child: _isLoading
            ? Center(
                child: LoadingAnimationWidget.prograssiveDots(
                color: AppPalette.blackColor,
                size: 50.sp,
              ))
            : _isUploaded
                ? Icon(Icons.check, size: 24.sp)
                : GestureDetector(
                    onTap: _uploadImage,
                    child: Icon(Icons.upload_rounded, size: 24.sp),
                  ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        Text(
          'Upload your profile picture',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: 319.w,
          child: RichText(
            text: TextSpan(
              text:
                  'Choose an Image from your gallery to use as your profile picture',
              style: TextStyle(
                color: AppPalette.greyColor0,
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return Center(
      child: _isLoading
          ? LoadingAnimationWidget.bouncingBall(
              color: AppPalette.blackColor,
              size: 50.sp,
            )
          : RoundedButton(
              name: "Let's proceed",
              onPressed: () async {
                if (_isSet) {
                  await _uploadImage();
                }
                UploadProfilePicPage.Route(context);
              },
            ),
    );
  }
}
