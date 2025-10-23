import 'package:isar/isar.dart';
import 'package:pix2life/core/error/app_failure.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';

abstract interface class ImageLocalDataSource {
  Future<void> storeCacheImages({required List<ImageModel> images});
  Future<List<ImageModel>> loadCachedImages();
}

class ImageLocalDataSourceImpl implements ImageLocalDataSource {
  final Isar isar;
  final logger = createLogger(ImageLocalDataSourceImpl);

  ImageLocalDataSourceImpl(this.isar);

  /// Stores a list of [ImageModel] objects in the cache by clearing the old cache and inserting new data.
  @override
  Future<void> storeCacheImages({required List<ImageModel> images}) async {
    try {
      await isar.writeTxn(() async {
        await isar.collection<ImageModel>().clear(); // Clear old cache
        await isar.collection<ImageModel>().putAll(images);
      });
    } on IsarError catch (e) {
      logger.e("IsarError: ${e.toString()}");
      throw const AppFailure(
          message: 'Failed to Store Cached Images', statusCode: 505);
    } catch (e) {
      logger.e(e.toString());
      throw const AppFailure(
          message: 'Failed to Store Cached Images', statusCode: 505);
    }
  }

  /// Loads cached images from the Isar collection and returns them as a list of [ImageModel] objects.
  @override
  Future<List<ImageModel>> loadCachedImages() async {
    try {
      final cachedImages =
          await isar.collection<ImageModel>().where().findAll();
      return cachedImages;
    } on IsarError catch (e) {
      logger.e("IsarError: ${e.toString()}");
      throw const AppFailure(
          message: 'Failed to Load Cached Images', statusCode: 505);
    } catch (e) {
      logger.e(e.toString());
      throw const AppFailure(
          message: 'Failed to Load Cached Images', statusCode: 505);
    }
  }
}
