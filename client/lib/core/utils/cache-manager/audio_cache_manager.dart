import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AudioCacheManager extends CacheManager {
  static const key = "audioCache";

  static final AudioCacheManager _instance = AudioCacheManager._();

  factory AudioCacheManager() {
    return _instance;
  }

  AudioCacheManager._()
      : super(Config(
          key,
          stalePeriod: Duration(days: 30), // Keep audio for 30 days
          maxNrOfCacheObjects: 50, // Limit the number of cached files
        ));
}
