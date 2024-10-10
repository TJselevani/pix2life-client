import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';

class MyImageProvider with ChangeNotifier {
  final BuildContext context;

  List<Photo> _images = [];
  Photo? _image;
  bool _loading = false;
  String _errorMessage = '';

  List<Photo> get images => _images;
  Photo? get image => _image;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyImageProvider(this.context) {
    // Start listening to ImageBloc state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final imageBloc = BlocProvider.of<ImageBloc>(context);

    // Listen for changes in the ImageBloc state
    imageBloc.stream.listen((state) {
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
      } else if (state is ImageFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    imageBloc.add(ImagesFetchEvent());
  }
}
