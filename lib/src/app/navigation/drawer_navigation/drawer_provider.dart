import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MyZoomDrawerProvider with ChangeNotifier {
  final ZoomDrawerController drawerController = ZoomDrawerController();

  void toggleDrawer() {
    drawerController.toggle!();
    notifyListeners();
  }

  bool isDrawerOpen() {
    return drawerController.isOpen!();
  }
}
