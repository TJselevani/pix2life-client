import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/pick-media/media_picker_service.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:provider/provider.dart';

class GalleryForm extends StatefulWidget {
  const GalleryForm({super.key});

  @override
  State<GalleryForm> createState() => _GalleryFormState();
}

class _GalleryFormState extends State<GalleryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _galleryNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final log = createLogger(GalleryForm);
  XFile? _image;
  final MediaPickerService _picker = MediaPickerService();
  bool isDarkMode = false;

  // Method to pick an image
  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickSingleImageCmp();
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if (state is GalleryFailure) {
          ErrorSnackBar.show(context: context, message: state.message);
          Navigator.of(context).pop();
        }

        if (state is GalleryCreated) {
          SuccessSnackBar.show(context: context, message: state.message);
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Create A New Gallery',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppPalette.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: isDarkMode
                  ? AppPalette.darkBackground
                  : AppPalette.lightBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 278,
                        width: 283,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isDarkMode
                              ? AppPalette.darkBackground
                              : AppPalette.lightBackground,
                        ),
                        child: Stack(
                          children: [
                            SizedBox.expand(
                              child: CircleAvatar(
                                backgroundImage:
                                    _image != null && _image!.path.isNotEmpty
                                        ? FileImage(File(_image!.path))
                                        : null,
                                backgroundColor: Colors.grey,
                                child: _image != null && _image!.path.isNotEmpty
                                    ? null
                                    : const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: AppPalette.red,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AuthInputField(
                        hintText: 'Gallery Name',
                        labelText: 'Gallery Name',
                        controller: _galleryNameController,
                        prefixIcon: null,
                        suffixIcon: null,
                      ),
                      const SizedBox(height: 12),
                      AuthInputField(
                        hintText: 'Gallery Description',
                        labelText: 'Gallery Description',
                        controller: _descriptionController,
                        prefixIcon: null,
                        suffixIcon: null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<GalleryBloc, GalleryState>(
                            builder: (context, state) {
                              if (state is GalleryLoading) {
                                return const Flexible(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppPalette.red,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              } else {
                                return Flexible(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.create, size: 15),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (_image != null &&
                                            _image!.path.isNotEmpty) {
                                          FormData formData = FormData.fromMap({
                                            "file":
                                                await MultipartFile.fromFile(
                                                    _image!.path,
                                                    filename: _image!.name),
                                            "galleryName":
                                                _galleryNameController.text
                                                    .trim(),
                                            "description":
                                                _descriptionController.text
                                                    .trim(),
                                          });

                                          BlocProvider.of<GalleryBloc>(context)
                                              .add(GalleryCreateEvent(
                                                  formData: formData));
                                        } else {
                                          ErrorSnackBar.show(
                                              context: context,
                                              message: 'Select Gallery Image');
                                        }
                                      }
                                    },
                                    label: const Text(
                                      'Create Gallery',
                                      style: TextStyle(
                                        color: AppPalette.red,
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      iconColor: AppPalette.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
