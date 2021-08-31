
import '../../../platform/image_storage/image_storage.dart';
import '../../../platform/image_storage/model.dart';
import '../../entities/photo.dart';

abstract class CameraRepository {
  Stream<PhotoEntity> get newestPhoto;
}

class CameraRepositoryImpl implements CameraRepository {
  final ImageStoragePlatform _imageStoragePlatform;

  CameraRepositoryImpl(this._imageStoragePlatform);

  @override
  Stream<PhotoEntity> get newestPhoto async* {
    yield (await _imageStoragePlatform.allImages).newest.toDomain();

    yield* _imageStoragePlatform.onImageStorageDataChanged
        .map((e) => e.newest.toDomain());
  }
}

extension on List<ImageDto> {
  ImageDto get newest => this.reduce((value, element) {
        if (value.creationDate.isAfter(element.creationDate)) {
          return value;
        } else {
          return element;
        }
      });
}
