import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_provider.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:provider/provider.dart';

class UpdateVideoScreen extends StatefulWidget {
  final Video video;

  const UpdateVideoScreen({required this.video, super.key});

  @override
  State<UpdateVideoScreen> createState() => _UpdateVideoScreenState();
}

class _UpdateVideoScreenState extends State<UpdateVideoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _galleryController;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.video.filename);
    _descriptionController =
        TextEditingController(text: widget.video.description);
    _galleryController = TextEditingController(text: widget.video.galleryName);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider =
          Provider.of<MyThemeProvider>(context, listen: false);
      setState(() {
        isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
      });
    });
  }

  void _updateVideo() {
    final videoProvider = Provider.of<MyVideoProvider>(context, listen: false);

    String updatedName = _nameController.text;
    String updatedDescription = _descriptionController.text;
    String updatedGallery = _galleryController.text;

    final DataMap updateData = {
      "galleryName": updatedGallery,
      "filename": updatedName,
      "description": updatedDescription,
    };

    videoProvider.updateVideo(widget.video, updateData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 32.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Edit video',
                style: TextStyle(
                  color: AppPalette.red,
                  fontFamily: 'Poppins',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildTextField(_nameController, 'Name'),
            SizedBox(height: 40.h),
            _buildTextField(_descriptionController, 'Description'),
            SizedBox(height: 40.h),
            BlocConsumer<VideoBloc, VideoState>(
                listener: (BuildContext context, VideoState state) {
              if (state is VideoUpdated) {
                Navigator.of(context).pop();
              }
            }, builder: (context, state) {
              if (state is VideoLoading) {
                return Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: AppPalette.red,
                    size: 50.sp,
                  ),
                );
              }

              return Center(
                child: ElevatedButton(
                  onPressed: _updateVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppPalette.primaryGrey,
          fontFamily: 'Poppins',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}
