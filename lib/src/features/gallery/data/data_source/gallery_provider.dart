import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';

class MyGalleryProvider with ChangeNotifier {
  final BuildContext context;
  late final StreamSubscription _gallerySubscription;

  List<Gallery> _galleries = [];
  bool _loading = false;
  String _errorMessage = '';

  List<Gallery> get galleries => _galleries;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyGalleryProvider(this.context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);

    // Store subscription to cancel later
    _gallerySubscription = galleryBloc.stream.listen((state) {
      if (state is GalleryLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is GalleriesLoaded) {
        _galleries = state.galleries;
        _loading = false;
        notifyListeners();
      } else if (state is GalleryCreated ||
          state is GalleryUpdated ||
          state is GalleryDeleted) {
        galleryBloc.add(GalleryFetchGalleriesEvent());
      } else if (state is GalleryFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    // Initial fetch of galleries
    galleryBloc.add(GalleryFetchGalleriesEvent());
  }

  Future<void> fetchGalleries() async {
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);
    galleryBloc.add(GalleryFetchGalleriesEvent());
  }

  // Dispose method to prevent memory leaks
  @override
  void dispose() {
    _gallerySubscription.cancel();
    super.dispose();
  }
}
