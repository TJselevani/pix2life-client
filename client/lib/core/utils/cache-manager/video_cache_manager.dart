import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheManager extends CacheManager {
  static const key = "videoCache";

  static final VideoCacheManager _instance = VideoCacheManager._();

  factory VideoCacheManager() {
    return _instance;
  }

  VideoCacheManager._()
      : super(Config(
          key,
          stalePeriod: Duration(days: 30), // Keep audio for 30 days
          maxNrOfCacheObjects: 50, // Limit the number of cached files
        ));
}
