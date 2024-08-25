import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditMediaScreen extends StatefulWidget {
  final dynamic data;
  final String type;

  const EditMediaScreen({required this.data, required this.type, Key? key})
      : super(key: key);

  @override
  _EditMediaScreenState createState() => _EditMediaScreenState();
}

class _EditMediaScreenState extends State<EditMediaScreen> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _descriptionController;
  final MediaService mediaService = MediaService();

  @override
  void initState() {
    super.initState();
    final Media media = Media.fromJson(widget.data);
    _idController = TextEditingController(text: media.id);
    _nameController = TextEditingController(text: media.filename);
    _descriptionController = TextEditingController(text: media.description);
  }

  void _updateMedia() async {
    String resourceId = _idController.text;
    String updatedName = _nameController.text;
    String updatedDescription = _descriptionController.text;
    final updateData = {
      "filename": updatedName,
      "description": updatedDescription,
    };
    try {
      final response = await _updateMediaByType(updateData, resourceId);
      SuccessSnackBar.show(context: context, message: response.message);
      Navigator.of(context).pop();
    } catch (e) {
      ErrorSnackBar.show(context: context, message: 'Update Failed: ${e}');
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> _updateMediaByType(
      Map<String, String> updateData, String resourceId) {
    switch (widget.type) {
      case 'image':
        return mediaService.updateImage(updateData, resourceId);
      case 'video':
        return mediaService.updateVideo(updateData, resourceId);
      case 'audio':
        return mediaService.updateAudio(updateData, resourceId);
      default:
        throw Exception('No media selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      appBar: AppBar(
        backgroundColor: AppPalette.whiteColor,
        elevation: 0,
        title: Text(
          'Edit Media',
          style: TextStyle(
            color: AppPalette.blackColor,
            fontFamily: 'Poppins',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 32.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_idController, 'Resource ID'),
              SizedBox(height: 20.h),
              _buildTextField(_nameController, 'Name'),
              SizedBox(height: 20.h),
              _buildTextField(_descriptionController, 'Description'),
              SizedBox(height: 40.h),
              Center(
                child: ElevatedButton(
                  onPressed: _updateMedia,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.greenColor,
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
              ),
            ],
          ),
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
          color: AppPalette.greyColor,
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

class Media {
  final String id;
  final String filename;
  final String path;
  final String originalName;
  final String ownerId;
  final String description;
  final String url;

  Media({
    required this.id,
    required this.filename,
    required this.path,
    required this.originalName,
    required this.ownerId,
    required this.description,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      filename: json['filename'],
      path: json['path'],
      originalName: json['originalName'],
      ownerId: json['ownerId'],
      description: json['description'],
      url: json['url'],
    );
  }
}
