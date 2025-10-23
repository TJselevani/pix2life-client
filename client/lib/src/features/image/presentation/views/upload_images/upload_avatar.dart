import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/permissions.dart';
import 'package:pix2life/core/utils/pick-media/media_picker_service.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/shared/widgets/buttons/hover_button.dart';
import 'package:provider/provider.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart'; // Added

class UploadProfilePicPage extends StatefulWidget {
  static routeToHomePage(context) {
    Navigator.pushReplacementNamed(context, '/Home');
  }

  static routeToGuide(context) {
    Navigator.pushReplacementNamed(context, '/Guide');
  }

  const UploadProfilePicPage({super.key});

  @override
  State<UploadProfilePicPage> createState() => _UploadProfilePicPageState();
}

class _UploadProfilePicPageState extends State<UploadProfilePicPage> {
  final MediaPickerService _picker = MediaPickerService();
  final log = createLogger(UploadProfilePicPage);
  bool _isSet = false;
  bool _isPending = false;
  bool _isUploaded = false;
  XFile? _image;
  User? authUser;
  bool isDarkMode = false;

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickAndCropImage();
    if (selectedImage != null) {
      setState(() {
        _isSet = true;
        _isPending = true;
        _isUploaded = false;
        _image = selectedImage;
      });
    }
  }

  _updateUser() {
    BlocProvider.of<AuthBloc>(context).add(AuthUserUpdatedEvent());
  }

  Future<void> _uploadImage() async {
    if (!mounted) return;

    XFile image = _image!;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: image.name),
    });

    BlocProvider.of<ImageBloc>(context).add(
      ImageUploadAvatarEvent(formData: formData),
    );
  }

  @override
  void initState() {
    super.initState();
    photoPermission();
    mediaPermission();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MyUserProvider>(context);
    final themeProvider = Provider.of<MyThemeProvider>(context); // Added
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final theme = Theme.of(context);
    authUser = userProvider.user;

    return MultiBlocListener(
      listeners: [
        BlocListener<ImageBloc, ImageState>(
          listener: (context, state) => {
            if (state is ImageFailure)
              {
                ErrorSnackBar.show(
                  context: context,
                  message: state.message,
                )
              },
            if (state is ImageSuccess)
              {
                setState(() {
                  _isPending = false;
                  _isUploaded = true;
                }),
                SuccessSnackBar.show(context: context, message: state.message),
                _updateUser()
              }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppPalette.primaryBlack,
        appBar: AppBar(
          backgroundColor: AppPalette.primaryBlack,
          elevation: 0,
          toolbarHeight: 64.h,
        ),
        body: Container(
          decoration: _buildBackgroundDecoration(theme), // Updated for theming
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Consumer<MyUserProvider>(
                        builder: (context, userProvider, child) {
                          if (userProvider.user != null) {
                            return Column(
                              children: [
                                _buildHeader(
                                    userProvider.user!, theme), // Updated
                                _buildProfileImage(userProvider.user!),
                              ],
                            );
                          } else {
                            return const Center(
                                child: Text('User not logged in.'));
                          }
                        },
                      ),
                      SizedBox(height: 40.h),
                      if (_isPending) _buildUploadIcon(theme), // Updated
                      SizedBox(height: 20.h),
                      if (!_isPending) _buildInstructions(theme), // Updated
                      _buildProceedButton(theme), // Updated
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(37.r),
      gradient: LinearGradient(
        colors: [
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildHeader(User authUser, ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
        borderRadius: BorderRadius.circular(37.w),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              width: 50.w,
              height: 5.h,
              color: isDarkMode
                  ? AppPalette.lightBackground
                  : AppPalette.darkBackground,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              child: Consumer(
                builder: (BuildContext context, value, Widget? child) {
                  return RichText(
                    text: TextSpan(
                      text: authUser.email,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontFamily: 'Poppins',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(User authUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          SizedBox(
            height: 278.h,
            width: 283.w,
            child: CircleAvatar(
              backgroundImage: _isSet && _image != null
                  ? FileImage(File(_image!.path))
                  : NetworkImage(
                      authUser.avatarUrl.isNotEmpty
                          ? authUser.avatarUrl
                          : AppImage.avatarUrl,
                    ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 40,
            child: _buildChooseImageButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildChooseImageButton() {
    return HoverButton(
      isWidget: true,
      widget: const Icon(
        Icons.add_a_photo,
        color: AppPalette.primaryWhite,
        size: 60,
      ),
      onPressed: _pickImage,
    );
  }

  Widget _buildUploadIcon(ThemeData theme) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        if (state is ImageLoading) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 15.h),
            child: Center(
              child: LoadingAnimationWidget.progressiveDots(
                color: theme.colorScheme.primary,
                size: 50.sp,
              ),
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 15.h),
            child: Center(
              child: _isUploaded
                  ? Icon(Icons.check, size: 24.sp)
                  : GestureDetector(
                      onTap: _uploadImage,
                      child: Icon(Icons.upload_rounded, size: 24.sp),
                    ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInstructions(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Upload your profile picture',
          style: theme.textTheme.headlineSmall?.copyWith(
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
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildProceedButton(ThemeData theme) {
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ImageLoading) {
          return LoadingAnimationWidget.bouncingBall(
            color: theme.colorScheme.primary,
            size: 50.sp,
          );
        } else {
          return RoundedButton(
            useColor: true,
            name: "Let's proceed",
            onPressed: () async {
              if (_isSet && _isPending) {
                await _uploadImage();
              }
              // ignore: use_build_context_synchronously
              UploadProfilePicPage.routeToHomePage(context);
            },
          );
        }
      },
    );
  }
}
