import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PhotoCacheManager extends CacheManager {
  static const key = "imageCache";

  static final PhotoCacheManager _instance = PhotoCacheManager._();

  factory PhotoCacheManager() {
    return _instance;
  }

  PhotoCacheManager._()
      : super(Config(
          key,
          stalePeriod: Duration(days: 30), // Keep audio for 30 days
          maxNrOfCacheObjects: 50, // Limit the number of cached files
        ));
}
