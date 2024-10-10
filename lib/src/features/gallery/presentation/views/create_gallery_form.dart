import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';

class GalleryForm extends StatefulWidget {
  const GalleryForm({super.key});

  @override
  State<GalleryForm> createState() => _GalleryFormState();
}

class _GalleryFormState extends State<GalleryForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _galleryNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final log = createLogger(GalleryForm);
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image
  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if (state is GalleryFailure) {
          ErrorSnackBar.show(context: context, message: state.message);
        }

        if (state is GallerySuccess) {
          SuccessSnackBar.show(context: context, message: state.message);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Gallery',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppPalette.red,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: AppPalette.primaryWhite,
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
                            color: AppPalette.primaryWhite,
                          ),
                          child: Stack(
                            children: [
                              SizedBox.expand(
                                child: CircleAvatar(
                                  backgroundImage:
                                      _image != null && _image!.path.isNotEmpty
                                          ? FileImage(File(_image!.path))
                                          : null,
                                  backgroundColor:
                                      Colors.grey, // Default background color
                                  child:
                                      _image != null && _image!.path.isNotEmpty
                                          ? null
                                          : const Icon(
                                              Icons
                                                  .image, // Default placeholder icon
                                              size: 50,
                                              color: Colors
                                                  .white, // Color of the placeholder icon
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
                          )),
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
                                      if (_image != null &&
                                          _image!.path.isNotEmpty) {
                                        FormData formData = FormData.fromMap({
                                          "file": await MultipartFile.fromFile(
                                              _image!.path,
                                              filename: _image!.name),
                                          "galleryName": _galleryNameController
                                              .text
                                              .trim(),
                                          "description": _descriptionController
                                              .text
                                              .trim(),
                                        });

                                        BlocProvider.of<GalleryBloc>(context)
                                            .add(GalleryCreateEvent(
                                                formData: formData));
                                        Navigator.of(context).pop();
                                      } else {
                                        ErrorSnackBar.show(
                                            context: context,
                                            message: 'Select Gallery Image');
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
