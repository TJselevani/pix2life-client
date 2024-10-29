import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/shared/widgets/buttons/square_button.dart';
import 'package:pix2life/src/shared/widgets/text-animation/fade_in_text.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class UploadMediaPage extends StatefulWidget {
  static route(context) => Navigator.pushReplacementNamed(context, '/Home');
  const UploadMediaPage({super.key});

  @override
  State<UploadMediaPage> createState() => _UploadMediaPageState();
}

class _UploadMediaPageState extends State<UploadMediaPage> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final log = createLogger(UploadMediaPage);
  List<XFile>? _videos = [];
  List<XFile>? _copyMedia = [];
  List<String> _uploadingMedia = [];
  List<String> _uploadDone = [];
  // List<Gallery> fetchedGalleries = [];
  List<String> galleryNames = [];
  bool isLoading = true;

  // final MediaService mediaService = MediaService();
  bool _isLoading = false;
  String _selectedMediaType = '';
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // _fetchGalleries();
  }

  // Future<void> _fetchGalleries() async {
  //   if (!mounted) return;
  //   try {
  //     final response = await mediaService.fetchGalleries();
  //     setState(() {
  //       fetchedGalleries = response.galleries;
  //       galleryNames = fetchedGalleries.map((gallery) => gallery.name).toList();
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     // Handle any errors here
  //     if (mounted)
  //       setState(() {
  //         isLoading = false;
  //       });
  //     log.e('Failed to fetch galleries: $e');
  //   }
  //   if (!mounted) return;
  // }

  Future<void> _pickVideo() async {
    setState(() {
      if (_selectedMediaType != 'videos') {
        _copyMedia = [];
      }
      // _selectedMediaType = 'videos';
    });
    final XFile? videoPicker =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (videoPicker != null) {
      setState(() {
        _videos!.add(videoPicker);
        _copyMedia!.add(videoPicker);
      });
    }
  }

  // ignore: unused_element
  Future<void> _uploadMedia<T>(
    List<XFile>? mediaList,
    Future Function(FormData formData, String galleryName) uploadFunction,
  ) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    if (mediaList == null || mediaList.isEmpty) {
      log.w('No media to upload');
      return;
    }

    await Future.forEach(mediaList, (XFile media) async {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(media.path, filename: media.name),
      });

      log.i('Uploading file: ${media.name}, path: ${media.path}');
      log.i('FormData being sent: ${formData.fields}');

      setState(() {
        _uploadingMedia.add(media.name);
      });

      try {
        final galleryName = _nameController.text.trim();
        log.i('Gallery name: $galleryName');

        // final response = await uploadFunction(formData, galleryName);

        if (!mounted) return;

        setState(() {
          // SuccessSnackBar.show(context: context, message: response.message);
          log.i('Successfully uploaded ${media.runtimeType}: ${media.name}');
          _uploadDone.add(media.name);
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          // ErrorSnackBar.show(context: context, message: '$e');
          log.e('Upload failed for ${media.runtimeType} ${media.name}: $e');
        });
      }
    });

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _videos = [];
      _copyMedia = [];
      _uploadingMedia = [];
      _uploadDone = [];
      _selectedMediaType = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.primaryWhite,
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
                    color: AppPalette.primaryBlack,
                  ),
                ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildMediaPreview(),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Text(
                'Upload Media to Gallery',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.w700,
                  color: AppPalette.primaryBlack,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(1)),
              if (_selectedMediaType.isNotEmpty) _buildMediaOptions(),
              SizedBox(height: ScreenUtil().setHeight(5)),
              if (_selectedMediaType.isNotEmpty)
                _isLoading
                    ? Center(
                        child: LoadingAnimationWidget.progressiveDots(
                          color: AppPalette.red,
                          size: ScreenUtil().setWidth(50),
                        ),
                      )
                    : _buildSaveButton(),
              SizedBox(height: ScreenUtil().setHeight(5)),
              Text(
                'Select the type of media you want to add.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                  color: AppPalette.primaryGrey,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              if (!_isLoading) _buildMediaSelectionButtons(),
              SizedBox(height: ScreenUtil().setHeight(25)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildUploadNotes(),
              SizedBox(height: ScreenUtil().setHeight(25)),
              // if (_selectedMediaType != '') _buildUploadedMediaList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedMediaType == 'videos' &&
        _videos != null &&
        _videos!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-3, 3),
            ),
          ],
        ),
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(250),
        child: _buildUploadedMediaList(),
        // child: ListView.builder(
        //   itemCount: _videos!.length,
        //   itemBuilder: (context, index) {
        //     return ListTile(
        //       title: Text(_videos![index].name),
        //     );
        //   },
        // ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: _copyMedia != null && _copyMedia!.isNotEmpty
                ? Colors.black.withOpacity(0.2)
                : AppPalette.red.withOpacity(0.7),
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(-3, 3),
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
                        ? const Icon(Icons.cloud)
                        : const Icon(Icons.cloud_circle),
                    title: Text(
                      media.name,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                      ),
                    ),
                    trailing: _uploadDone.contains(media.name)
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
                );
              },
            )
          : const Center(child: FadeInText(text: 'PIX2LIFE')),
    );
  }

  Widget _buildMediaSelectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _buildMediaButton('Video', _pickVideo),
        ),
      ],
    );
  }

  Widget _buildMediaButton(String name, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity.w,
      child: SquareButton(
        name: name,
        onPressed: () {
          switch (name) {
            case 'Video':
              setState(() {
                _selectedMediaType = 'videos';
              });
              break;
            case 'Image':
              setState(() {
                _selectedMediaType = 'images';
              });
              break;
            case 'Audio':
              setState(() {
                _selectedMediaType = 'audios';
              });
              break;
            default:
              log.i('No media selected');
          }

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
          // switch (_selectedMediaType) {
          //   case 'images':
          //     _uploadMedia(_images, mediaService.uploadImage);
          //     break;
          //   case 'videos':
          //     _uploadMedia(_videos, mediaService.uploadVideo);
          //     break;
          //   case 'audios':
          //     _uploadMedia(_audios, mediaService.uploadAudio);
          //     break;
          //   default:
          //     ErrorSnackBar.show(
          //         context: context, message: 'No media selected');
          // }
        },
        child: const Center(
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
            color: AppPalette.primaryGrey,
          ),
        ),
        ..._uploadNotes.map((note) => Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
              child: RichText(
                text: TextSpan(
                  text: note,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: ScreenUtil().setSp(11),
                    fontWeight: FontWeight.w700,
                    color: AppPalette.primaryGrey,
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
                  ? const Icon(Icons.cloud)
                  : const Icon(Icons.cloud_circle),
              title: Text(media.name),
              trailing: _uploadDone.contains(media.name)
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMediaOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(1)),
      child: Column(
        children: [
          Text(
            'Choose a Gallery',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500,
              color: AppPalette.primaryBlack,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          DropdownButton<String>(
            value: _selectedOption,
            hint: const Text('Select gallery'),
            items: galleryNames.map((String name) {
              return DropdownMenuItem<String>(
                value: name,
                child: Text(name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue;
                // Pass the selected gallery name to your function here
                _nameController.text = newValue ?? '';
              });
            },
          ),
        ],
      ),
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
          color: AppPalette.primaryGrey,
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
