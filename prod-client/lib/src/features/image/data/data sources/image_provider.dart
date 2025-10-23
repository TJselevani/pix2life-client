import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';

class MyImageProvider with ChangeNotifier {
  final BuildContext context;
  late final StreamSubscription _imageSubscription;

  List<Photo> _images = [];
  Photo? _image;
  bool _loading = false;
  String _errorMessage = '';

  List<Photo> get images => _images;
  Photo? get image => _image;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyImageProvider(this.context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final imageBloc = BlocProvider.of<ImageBloc>(context);

    // Store subscription to cancel it later
    _imageSubscription = imageBloc.stream.listen((state) {
      if (state is ImageLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is ImagesLoaded) {
        _images = state.images;
        _loading = false;
        notifyListeners();
      } else if (state is ImageLoaded) {
        _image = state.image;
        _loading = false;
        notifyListeners();
      } else if (state is ImageUpdated) {
        imageBloc.add(ImagesFetchEvent()); // Refetch images after update
        notifyListeners();
      } else if (state is ImageDeleted) {
        imageBloc.add(ImagesFetchEvent()); // Refetch images after deletion
        notifyListeners();
      } else if (state is ImageFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    // Initial fetch of images
    imageBloc.add(ImagesFetchEvent());
  }

  Future<void> fetchImages() async {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    imageBloc.add(ImagesFetchEvent());
  }

  // Method to delete an image by ID
  Future<void> deleteImage(String imageId) async {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    imageBloc.add(ImageDeleteEvent(imageId: imageId));

    // Wait for response from Bloc
    await for (var state in imageBloc.stream) {
      if (state is ImageDeleted) {
        imageBloc.add(ImagesFetchEvent()); // Refresh images after deletion
        _loading = false;
        notifyListeners();
        break;
      } else if (state is ImageFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
        break;
      }
    }
  }

  // Method to update an image
  Future<void> updateImage(Photo image, DataMap updateData) async {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    imageBloc.add(ImageUpdateEvent(image: image, updateData: updateData));

    // Wait for response from Bloc
    await for (var state in imageBloc.stream) {
      if (state is ImageUpdated) {
        imageBloc.add(ImagesFetchEvent()); // Refresh images after update
        _loading = false;
        notifyListeners();
        break;
      } else if (state is ImageFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
        break;
      }
    }
  }

  // Dispose method to prevent memory leaks
  @override
  void dispose() {
    _imageSubscription.cancel();
    super.dispose();
  }
}
