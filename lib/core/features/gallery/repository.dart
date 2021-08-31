import 'package:async/async.dart';

import '../../../platform/image_storage/image_storage.dart';
import '../../entities/photo.dart';

typedef AllPhotosResult = Result<List<PhotoEntity>>;

abstract class GalleryRepository {
  Future<AllPhotosResult> get allPhotos;
}

class GalleryRepositoryImpl implements GalleryRepository {
  final ImageStoragePlatform _imageStoragePlatform;

  GalleryRepositoryImpl(this._imageStoragePlatform);

  @override
  Future<AllPhotosResult> get allPhotos async {
    try {
      final result = (await _imageStoragePlatform.allImages)
          .map((e) => e.toDomain())
          .toList();

      return Result.value(result);
    } catch (e) {
      return Result.error(e);
    }
  }
}
