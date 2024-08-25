import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/square_button.dart';
import 'package:pix2life/config/common/text_animations.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadMediaPage extends StatefulWidget {
  static route(context) => Navigator.pushReplacementNamed(context, '/Home');
  const UploadMediaPage({super.key});

  @override
  State<UploadMediaPage> createState() => _UploadMediaPageState();
}

class _UploadMediaPageState extends State<UploadMediaPage> {
  TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final log = logger(UploadMediaPage);
  List<XFile>? _images = [];
  List<XFile>? _videos = [];
  List<XFile>? _audios = [];
  List<XFile>? _copyMedia = [];
  List<String> _uploadingMedia = [];
  List<String> _uploadDone = [];

  final MediaService mediaService = MediaService();
  bool _isLoading = false;
  String _selectedMediaType = '';

  String encodeFileName(String fileName) {
    return Uri.encodeComponent(fileName);
  }

  // Future<void> _pickImages() async {
  //   final List<XFile> selectedImages = await _picker.pickMultiImage();
  //   if (selectedImages.isNotEmpty) {
  //     setState(() {
  //       _images!.addAll(selectedImages);
  //       _copyMedia = selectedImages;
  //       _selectedMediaType = 'images';
  //     });
  //   }
  // }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    ))
        ?.files
        .map((file) => XFile(file.path!))
        .toList();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _images!.addAll(selectedImages);
        _copyMedia!.addAll(selectedImages);
        _selectedMediaType = 'images';
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? videoPicker =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (videoPicker != null) {
      setState(() {
        _copyMedia!.add(videoPicker);
        _videos!.add(videoPicker);
        _selectedMediaType = 'videos';
      });
    }
  }

  Future<void> _pickAudios() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );
      if (result != null) {
        List<XFile> audioFiles =
            result.paths.map((path) => XFile(path!)).toList();
        setState(() {
          _audios!.addAll(audioFiles);
          _copyMedia!.addAll(audioFiles);
          _selectedMediaType = 'audios';
        });
      }
    } catch (e) {
      debugPrint('Error picking audio files: $e');
    }
  }

  Future<void> _uploadMedia<T>(
    List<XFile>? mediaList,
    Future Function(FormData formData, String galleryName) uploadFunction,
  ) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    await Future.forEach(mediaList!, (XFile media) async {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(media.path, filename: media.name),
      });

      setState(() {
        _uploadingMedia.add(media.name);
      });

      try {
        final galleryName = _nameController.text.trim();
        final response = await uploadFunction(formData, galleryName);

        if (!mounted) return;

        setState(() {
          SuccessSnackBar.show(context: context, message: response.message);
          log.i('Successfully uploaded ${media.runtimeType}: ${media.name}');
          _uploadDone.add(media.name);
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          ErrorSnackBar.show(context: context, message: '$e');
          log.e('Upload failed for ${media.runtimeType} ${media.name}: $e');
        });
      }
    });

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _images = [];
      _videos = [];
      _audios = [];
      _copyMedia = [];
      _uploadingMedia = [];
      _uploadDone = [];
      _selectedMediaType = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(15),
          0,
          ScreenUtil().setWidth(15),
          ScreenUtil().setHeight(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtil().setHeight(10)),
              if (_selectedMediaType.isNotEmpty)
                Text(
                  'Selected Media Type: $_selectedMediaType',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.w700,
                    color: AppPalette.blackColor2,
                  ),
                ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildMediaPreview(),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Text(
                'Upload Media to Gallery',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: ScreenUtil().setSp(25),
                  fontWeight: FontWeight.w700,
                  color: AppPalette.blackColor3,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              Text(
                'Select the type of media you want to add.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: ScreenUtil().setSp(17),
                  fontWeight: FontWeight.w400,
                  color: AppPalette.greyColor2,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              if (!_isLoading) _buildMediaSelectionButtons(),
              SizedBox(height: ScreenUtil().setHeight(25)),
              if (_selectedMediaType.isNotEmpty)
                _isLoading
                    ? Center(
                        child: LoadingAnimationWidget.prograssiveDots(
                          color: AppPalette.redColor1,
                          size: ScreenUtil().setWidth(50),
                        ),
                      )
                    : _buildSaveButton(),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildUploadNotes(),
              SizedBox(height: ScreenUtil().setHeight(25)),
              if (_selectedMediaType == 'images') _buildUploadedMediaList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_images != null && _images!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(-3, 3),
            ),
          ],
        ),
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(250),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ImageSelectionContainer(
                        imagePath: _images![index].path,
                        onRemove: () {
                          setState(() {
                            _images!.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
                itemCount: _images!.length,
              ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: _copyMedia != null && _copyMedia!.isNotEmpty
                ? Colors.black.withOpacity(0.2)
                : AppPalette.redColor1.withOpacity(0.7),
            spreadRadius: 4,
            blurRadius: 5,
            offset: Offset(-3, 3),
          ),
        ],
      ),
      width: ScreenUtil().setWidth(250),
      height: ScreenUtil().setHeight(250),
      child: _copyMedia != null && _copyMedia!.isNotEmpty
          ? ListView.builder(
              itemCount: _copyMedia!.length,
              itemBuilder: (context, index) {
                XFile media = _copyMedia![index];
                return SizedBox(
                  width: ScreenUtil().setWidth(230),
                  child: ListTile(
                    leading: _uploadingMedia.contains(media.name)
                        ? Icon(Icons.cloud)
                        : Icon(Icons.cloud_circle),
                    title: Text(
                      media.name,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                      ),
                    ),
                    trailing: _uploadDone.contains(media.name)
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
                );
              },
            )
          : Center(child: FadeInText()),
    );
  }

  Widget _buildMediaSelectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMediaButton('Video', _pickVideo),
        _buildMediaButton('Image', _pickImages),
        _buildMediaButton('Audio', _pickAudios),
      ],
    );
  }

  Widget _buildMediaButton(String name, VoidCallback onPressed) {
    return SizedBox(
      width: ScreenUtil().setWidth(100),
      child: SquareButton(
        name: name,
        onPressed: () {
          setState(() {
            _images = [];
            _audios = [];
            _videos = [];
            _copyMedia = [];
            _selectedMediaType = '';
          });
          onPressed();
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child: GestureDetector(
        onTap: () {
          switch (_selectedMediaType) {
            case 'images':
              _uploadMedia(_images, mediaService.uploadImage);
              break;
            case 'videos':
              _uploadMedia(_videos, mediaService.uploadVideo);
              break;
            case 'audios':
              _uploadMedia(_audios, mediaService.uploadAudio);
              break;
            default:
              ErrorSnackBar.show(
                  context: context, message: 'No media selected');
          }
        },
        child: Center(
          child: SquareButton(name: 'SAVE GALLERY'),
        ),
      ),
    );
  }

  Widget _buildUploadNotes() {
    return Column(
      children: [
        Text(
          'Note:',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: ScreenUtil().setSp(15),
            fontWeight: FontWeight.w900,
            color: AppPalette.greyColor2,
          ),
        ),
        ..._uploadNotes.map((note) => Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
              child: RichText(
                text: TextSpan(
                  text: note,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: ScreenUtil().setSp(13),
                    fontWeight: FontWeight.w700,
                    color: AppPalette.greyColor2,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }

  List<String> get _uploadNotes => [
        "1. Select Specific Media Above",
        "2. Provide New or Existing Gallery Name",
        "3. Do not leave the page During Upload process",
        "4. You can only upload one type of media at a time",
      ];

  Widget _buildUploadedMediaList() {
    return Column(
      children: _copyMedia!.map((media) {
        return Center(
          child: SizedBox(
            width: ScreenUtil().setWidth(230),
            child: ListTile(
              leading: _uploadingMedia.contains(media.name)
                  ? Icon(Icons.cloud)
                  : Icon(Icons.cloud_circle),
              title: Text(media.name),
              trailing: _uploadDone.contains(media.name)
                  ? Icon(Icons.check, color: Colors.green)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ImageSelectionContainer extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onRemove;

  const ImageSelectionContainer({
    super.key,
    required this.imagePath,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppPalette.greyColor,
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
