import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePlayerProWidget extends StatefulWidget {
  final String imageUrl;

  const ImagePlayerProWidget({super.key, required this.imageUrl});

  @override
  State<ImagePlayerProWidget> createState() => _ImagePlayerProWidgetState();
}

class _ImagePlayerProWidgetState extends State<ImagePlayerProWidget> {
  bool _isFullScreen = false;

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Dialog(
              insetPadding: EdgeInsets.all(0),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: GestureDetector(
                      onDoubleTap: _toggleFullScreen,
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: _isFullScreen
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width * 0.9,
                          height: _isFullScreen
                              ? MediaQuery.of(context).size.height
                              : MediaQuery.of(context).size.height * 0.7,
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                          // Image.network(widget.imageUrl, fit: BoxFit.contain),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
