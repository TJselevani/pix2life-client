import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/images.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:pix2life/config/common/text_animations.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:pix2life/models/entities/user.model.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadProfilePicPage extends StatefulWidget {
  static Route(context) {
    Navigator.pushReplacementNamed(context, '/Home');
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
      "image": await MultipartFile.fromFile(image.path, filename: image.name),
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
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            _buildHeader(authUser),
            _buildProfileImage(authUser),
            _buildChooseImageButton(),
            _buildUploadIcon(),
            _buildInstructions(),
            _buildProceedButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User authUser) {
    return Expanded(
      child: Container(
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
              SizedBox(height: 40.h),
              SizedBox(
                width: 247.w,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(User authUser) {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        height: 278.h,
        width: 283.w,
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
    return SizedBox(
      height: 20.h,
      child: Center(
        child: _isPending
            ? GestureDetector(
                onTap: _uploadImage,
                child: Icon(Icons.upload_rounded, size: 24.sp),
              )
            : _isUploaded
                ? Icon(Icons.check, size: 24.sp)
                : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          'Upload your profile picture',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 30.h),
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
    return SizedBox(
      height: 40.h,
      child: Center(
        child: _isLoading
            ? LoadingAnimationWidget.prograssiveDots(
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
      ),
    );
  }
}
