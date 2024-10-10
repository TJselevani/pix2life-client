import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';

class MyGalleryProvider with ChangeNotifier {
  final BuildContext context;

  List<Gallery> _galleries = [];
  bool _loading = false;
  String _errorMessage = '';

  List<Gallery> get galleries => _galleries;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyGalleryProvider(this.context) {
    // Start listening to GalleryBloc state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);

    // Listen for changes in the AudioBloc state
    galleryBloc.stream.listen((state) {
      if (state is GalleryLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is GalleriesLoaded) {
        _galleries = state.galleries;
        _loading = false;
        notifyListeners();
      } else if (state is GalleryFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    galleryBloc.add(GalleryFetchGalleriesEvent());
  }
}
